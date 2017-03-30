# Cleaning Up

## Kubernetes Resources

```
kubectl --context=federation-cluster delete services nginx
```

```
kubectl --context=federation-cluster delete ing nginx
```

```
CLUSTERS="asia-east1-b europe-west1-b us-east1-b us-central1-b"
```

```
kubectl --context=federation-cluster delete clusters ${CLUSTERS[*]}
```

```
kubectl config use-context host-cluster
```

```
kubectl delete ns federation
```

## DNS Managed Zone

The managed zone must be empty before you can delete it. Visit the Cloud DNS console and delete all resource records before running the following command:

```
gcloud dns managed-zones delete federation
```

## GKE Clusters

Delete the four GKE clusters:

```
gcloud container clusters delete asia-east1-b -q --zone=asia-east1-b
```

```
gcloud container clusters delete europe-west1-b -q --zone=europe-west1-b
```

```
gcloud container clusters delete us-central1-b -q --zone=us-central1-b
```

```
gcloud container clusters delete us-east1-b -q --zone=us-east1-b
```
