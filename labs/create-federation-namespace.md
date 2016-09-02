# Federation Namespace

## Prerequisites

### Store the GCP Project Name

```
export GCP_PROJECT=$(gcloud config list --format='value(core.project)')
```

## Create the Federation Namespace

The Kubernetes federation control plane will run in the federation namespace. Create the federation namespace using kubectl:

```
kubectl --context="gke_${GCP_PROJECT}_us-central1-b_gce-us-central1" \
  create -f ns/federation.yaml
```
