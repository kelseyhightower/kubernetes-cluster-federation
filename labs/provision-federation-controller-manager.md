# Provision Federated Controller Manager

## Prerequisites

### Store the GCP Project Name

```
export GCP_PROJECT=$(gcloud config list --format='value(core.project)')
```

### Create the Federation API Sever Secret Token

The Federation API Sever token was created in the previous lab.

* [Create the Federation API Sever Secret Token](provision-federation-apiserver.md#create-the-federation-api-server-secret)

## Create the Federated API Server Kubeconfig

The federation-controller-manager needs a kubeconfig file to connect to the federation-apiserver.

Get the federated API server public IP address:

```
FEDERATED_API_SERVER_ADDRESS=$(kubectl --context="gke_${GCP_PROJECT}_us-central1-b_gce-us-central1" \
  --namespace=federation \
  get services federation-apiserver \
  -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
```

Use the `kubectl config` command to build up a kubeconfig file for the federated API server:

```
kubectl config set-cluster federation-cluster \
  --server=https://${FEDERATED_API_SERVER_ADDRESS} \
  --insecure-skip-tls-verify=true
```

Get the token from the `known-tokens.csv` file:

```
FEDERATION_CLUSTER_TOKEN=$(cut -d"," -f1 known-tokens.csv)
```

```
kubectl config set-credentials federation-cluster \
  --token=${FEDERATION_CLUSTER_TOKEN}
```

> The `--token` flag must be set to the same token used in the known-tokens.csv.

```
kubectl config set-context federation-cluster \
  --cluster=federation-cluster \
  --user=federation-cluster
```

Switch to the `federation-cluster` context and dump the federated API server credentials:

```
kubectl config use-context federation-cluster
```

```
kubectl  config view --flatten --minify > kubeconfigs/federation-apiserver/kubeconfig
```

#### Create the Federated API Server Secret

Switch to the host cluster context and create the `federation-apiserver-kubeconfig`, which holds the kubeconfig for the federated API server used by the Federated Controller Manager.

```
kubectl --context="gke_${GCP_PROJECT}_us-central1-b_gce-us-central1" \
  --namespace=federation \
  create secret generic federation-apiserver-kubeconfig \
  --from-file=kubeconfigs/federation-apiserver/kubeconfig
```

Verify

```
kubectl --context="gke_${GCP_PROJECT}_us-central1-b_gce-us-central1" \
  --namespace=federation \
  describe secrets federation-apiserver-kubeconfig
```

### Deploy the Federated Controller Manager

```
kubectl --context="gke_${GCP_PROJECT}_us-central1-b_gce-us-central1" \
  --namespace=federation \
  create -f deployments/federation-controller-manager.yaml
```

Wait for the `federation-controller-manager` pod to be running.

```
kubectl --context="gke_${GCP_PROJECT}_us-central1-b_gce-us-central1" \
  --namespace=federation \
  get pods
```

```
NAME                                             READY     STATUS    RESTARTS   AGE
federation-apiserver-116423504-4mwe8             2/2       Running   0          12m
federation-controller-manager-1899587413-c1c1w   1/1       Running   0          16s
```
