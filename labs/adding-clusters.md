# Adding Clusters

With the federated control plane in place we are ready to start adding clusters to our federation.

To add a cluster to the federation you will need the following information:

* A vaild kubeconfig for each cluster stored in a Kubernetes secret
* A cluster object added to the Federated API Server

## Prerequisites

### Store the GCP Project Name

```
export GCP_PROJECT=$(gcloud config list --format='value(core.project)')
```

## Create the Cluster Objects

### gce-asia-east1

```
kubectl --context="gke_${GCP_PROJECT}_us-central1-b_gce-us-central1" \
  --namespace=federation \
  create secret generic gce-asia-east1 \
  --from-file=kubeconfigs/gce-asia-east1/kubeconfig
```

```
kubectl --context=federation-cluster \
  create -f clusters/gce-asia-east1.yaml
```

### gce-europe-west1

```
kubectl --context="gke_${GCP_PROJECT}_us-central1-b_gce-us-central1" \
  --namespace=federation \
  create secret generic gce-europe-west1 \
  --from-file=kubeconfigs/gce-europe-west1/kubeconfig
```

```
kubectl --context=federation-cluster \
  create -f clusters/gce-europe-west1.yaml
```

### gce-us-central1

```
kubectl --context="gke_${GCP_PROJECT}_us-central1-b_gce-us-central1" \
  --namespace=federation \
  create secret generic gce-us-central1 \
  --from-file=kubeconfigs/gce-us-central1/kubeconfig
```

```
kubectl --context=federation-cluster \
  create -f clusters/gce-us-central1.yaml
```

### gce-us-east1

```
kubectl --context="gke_${GCP_PROJECT}_us-central1-b_gce-us-central1" \
  --namespace=federation \
  create secret generic gce-us-east1 \
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
