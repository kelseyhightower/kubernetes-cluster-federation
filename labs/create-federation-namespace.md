# Federation Namespace

## Create the Federation Namespace

The Kubernetes federation control plane will run in the federation namespace. Create the federation namespace using kubectl:

```
export GCP_PROJECT=$(gcloud config list --format='value(core.project)')
```

```
kubectl --context="gke_${GCP_PROJECT}_asia-east1-b_gce-asia-east1" \
  create -f ns/federation.yaml
```
