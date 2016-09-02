# Cleaning Up

## Kubernetes Objects

```
kubectl --context=federation-cluster delete clusters \
  gce-asia-east1 gce-europe-west1 gce-us-central1 gce-us-east1
```
```
cluster "gce-asia-east1" deleted
cluster "gce-europe-west1" deleted
cluster "gce-us-central1" deleted
cluster "gce-us-east1" deleted
```

```
kubectl --context=federation-cluster delete services nginx
```

```
kubectl --namespace=federation delete pods,svc,rc,deployment,secret --all
```

## DNS Managed Zone

The managed zone must be empty before you can delete it. Visit the Cloud DNS console and delete all resource records before running the following command:

```
gcloud dns managed-zones delete federation
```

## GKE Clusters

Delete the 4 GKE clusters.

```
gcloud container clusters delete gce-asia-east1 --zone=asia-east1-b
gcloud container clusters delete gce-europe-west1 --zone=europe-west1-b
gcloud container clusters delete gce-us-central1 --zone=us-central1-b
gcloud container clusters delete gce-us-east1 --zone=us-east1-b
```
