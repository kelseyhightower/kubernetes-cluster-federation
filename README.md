# Federated Kubernetes Tutorial

This guide will walk you through testing the upcoming support for cluster federation in Kubernetes 1.3. This guide will cover the cross-cluster load balancing and service discovery features as documented in the [Kubernetes Cluster Federation aka Ubernetes design doc](https://github.com/kubernetes/kubernetes/blob/release-1.3/docs/design/federated-services.md) 

## Prerequisites

### Clone This Repository

Frist checkout this repostory which contains the Kubernetes configs required to build the federated control plane.

```
git clone https://github.com/kelseyhightower/kubernetes-cluster-federation.git
cd kubernetes-cluster-federation
```

### Bootrapping Tasks

Next complete each of the following tasks in order.

* [Provision Kubernetes Clusters](labs/cluster-bootstrap.md)
* [Create Cluster Secrets and Manifests](labs/create-cluster-secrets-and-manifests.md)
* [Create GCE DNS Managed Zone](labs/cluster-dns-managed-zone.md)
* [Download an Updated Kubernetes](labs/download-an-updated-kubectl-client.md)

> kubectl 1.3.0 or later is required to work with a federated Kubernetes control plane.

## Provision Federated Control Plane

The Kubernetes federated control plane consists of two services:

* federation-apiserver
* federation-controller-manager

List all contexts in your local kubeconfig:

```
for c in $(kubectl config view -o jsonpath='{.contexts[*].name}'); do echo $c; done
```

Both services need to run in a host Kubernetes cluster. Use the gce-us-central1 cluster as the host cluster.

```
kubectl config use-context gke_hightowerlabs_us-central1-b_gce-us-central1
```

> Your context names will be different. Replace hightowerlabs with your GCP project name. 

### Federation Namespace

The Kubernetes federation control plane will run in the federation namespace. Create the federation namespace using kubectl:

```
kubectl create -f ns/federation.yaml
```

### Provision Federated Services

* [Provision the Federated API Server](labs/provision-federation-apiserver.md)
* [Provision the Federated Controller Manager](labs/provision-federation-controller-manager.md)

## Adding Clusters

With the federated control plane in place we are ready to start adding clusters to our federation.

> kubectl 1.3.0 or later is required to work with a federated Kubernetes control plane. See the [prerequisites](#prerequisites) 

### gce-asia-east1

```
kubectl --namespace=federation create secret generic gce-asia-east1 \
  --from-file=kubeconfigs/gce-asia-east1/kubeconfig
```

```
kubectl --context=federation-cluster \
  create -f clusters/gce-asia-east1.yaml
```

### gce-europe-west1

```
kubectl --namespace=federation create secret generic gce-europe-west1 \
  --from-file=kubeconfigs/gce-europe-west1/kubeconfig
```

```
kubectl --context=federation-cluster \
  create -f clusters/gce-europe-west1.yaml
```

### gce-us-central1

```
kubectl --namespace=federation create secret generic gce-us-central1 \
  --from-file=kubeconfigs/gce-us-central1/kubeconfig
```

```
kubectl --context=federation-cluster \
  create -f clusters/gce-us-central1.yaml
```

### gce-us-east1

```
kubectl --namespace=federation create secret generic gce-us-east1 \
  --from-file=kubeconfigs/gce-us-east1/kubeconfig
```

```
kubectl --context=federation-cluster \
  create -f clusters/gce-us-east1.yaml
```

### Verify

```
kubectl --context=federation-cluster get clusters
```
```
NAME               STATUS    VERSION   AGE
gce-asia-east1     Ready               1m
gce-europe-west1   Ready               57s
gce-us-central1    Ready               47s
gce-us-east1       Ready               34s
```

## Running Federated Workloads

Create a federated service object in the `federation-cluster` context.

```
kubectl --context=federation-cluster create -f services/nginx.yaml
```

Wait until the nginx service is propagated across all 4 clusters and the federated service is updated with the details. Currently this can take up to 5 mins to complete.

### Verify

```
kubectl --context=federation-cluster describe services nginx
```
```
Name:                   nginx
Namespace:              default
Labels:                 run=nginx
Selector:               run=nginx
Type:                   LoadBalancer
IP:			
LoadBalancer Ingress:   104.197.246.190, 130.211.57.243, 104.196.14.231, 104.199.136.89
Port:                   http    80/TCP
Endpoints:		        <none>
Session Affinity:	    None
No events.
```

List all contexts in your local kubeconfig

```
for c in $(kubectl config view -o jsonpath='{.contexts[*].name}'); do echo $c; done
```

View the nginx service in each Kubernetes cluster, which was created by the federated controller manager.

```
kubectl --context=gke_hightowerlabs_asia-east1-b_gce-asia-east1 get svc nginx
```
```
NAME      CLUSTER-IP     EXTERNAL-IP      PORT(S)   AGE
nginx     10.63.250.98   104.199.136.89   80/TCP    9m
```

### Create Nginx Deployments

```
kubectl --context="gke_hightowerlabs_asia-east1-b_gce-asia-east1" \
  run nginx --image=nginx:1.11.1-alpine --port=80
```

```
kubectl --context="gke_hightowerlabs_europe-west1-b_gce-europe-west1" \
  run nginx --image=nginx:1.11.1-alpine --port=80
```

```
kubectl --context=gke_hightowerlabs_us-central1-b_gce-us-central1 \
  run nginx --image=nginx:1.11.1-alpine --port=80
```

```
kubectl --context="gke_hightowerlabs_us-east1-b_gce-us-east1" \
  run nginx --image=nginx:1.11.1-alpine --port=80
```

### Review Cloud DNS Console

The Federated controller manager creates DNS entires in the configured zone.

![Google Cloud DNS](images/googledns.png)

## Cleanup

### Kubernetes Objects

```
kubectl --context=federation-cluster delete services nginx
```

```
kubectl --namespace=federation delete pods,svc,rc,deployment,secret --all
```

### DNS Managed Zone

The managed zone must be empty before you can delete it. Visit the Cloud DNS console and delete all resource records before running the following command:

```
gcloud dns managed-zones delete federation
```

### GKE Clusters

Delete the 4 GKE clusters.

```
gcloud container clusters delete gce-asia-east1 --zone=asia-east1-b
gcloud container clusters delete gce-europe-west1 --zone=europe-west1-b
gcloud container clusters delete gce-us-central1 --zone=us-central1-b
gcloud container clusters delete gce-us-east1 --zone=us-east1-b
```
