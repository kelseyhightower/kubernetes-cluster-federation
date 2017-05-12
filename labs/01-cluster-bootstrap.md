# Provision Kubernetes Clusters

This tutorial will walk you through setting up Kubernetes clusters in four GCP regions using GKE.

## Create Clusters

Use the `gcloud container clusters create` command to create a Kubernetes clusters in the following zones:

* asia-east1-b
* europe-west1-b
* us-east1-b
* us-central1-b 

Run the following commands in a separate terminal for parallel execution.

Create the `asia-east1-b` cluster:

```
gcloud beta container clusters create asia-east1-b \
  --cluster-version 1.6.2 \
  --zone asia-east1-b \
  --scopes "cloud-platform,storage-ro,logging-write,monitoring-write,service-control,service-management,https://www.googleapis.com/auth/ndev.clouddns.readwrite"
```

Create the `europe-west1-b` cluster:

```
gcloud beta container clusters create europe-west1-b \
  --cluster-version 1.6.2 \
  --zone=europe-west1-b \
  --scopes "cloud-platform,storage-ro,logging-write,monitoring-write,service-control,service-management,https://www.googleapis.com/auth/ndev.clouddns.readwrite"
```

Create the `us-east1-b` cluster:

```
gcloud beta container clusters create us-east1-b \
  --cluster-version 1.6.2 \
  --zone=us-east1-b \
  --scopes "cloud-platform,storage-ro,logging-write,monitoring-write,service-control,service-management,https://www.googleapis.com/auth/ndev.clouddns.readwrite"
```

Create the `us-central1-b` cluster:

```
gcloud beta container clusters create us-central1-b \
  --cluster-version 1.6.2 \
  --zone=us-central1-b \
  --scopes "cloud-platform,storage-ro,logging-write,monitoring-write,service-control,service-management,https://www.googleapis.com/auth/ndev.clouddns.readwrite"
```

Save the cluster credentials:

```
for cluster in asia-east1-b europe-west1-b us-east1-b us-central1-b; do
  gcloud container clusters get-credentials ${cluster} \
  --zone ${cluster}
done
```

## Create Cluster Contexts

```
GCP_PROJECT=$(gcloud config list --format='value(core.project)')
```

Create context aliases:

```
for cluster in asia-east1-b europe-west1-b us-east1-b us-central1-b; do
  kubectl config set-context ${cluster} \
    --cluster=gke_${GCP_PROJECT}_${cluster}_${cluster} \
    --user=gke_${GCP_PROJECT}_${cluster}_${cluster}
done
```

Create the host cluster context:

```
HOST_CLUSTER=us-central1-b
```

```
kubectl config set-context host-cluster \
  --cluster=gke_${GCP_PROJECT}_${HOST_CLUSTER}_${HOST_CLUSTER} \
  --user=gke_${GCP_PROJECT}_${HOST_CLUSTER}_${HOST_CLUSTER} \
  --namespace=federation
```


### Verify

```
gcloud container clusters list
```

```
NAME            ZONE            MASTER_VERSION  MASTER_IP        MACHINE_TYPE   NODE_VERSION  NUM_NODES  STATUS
asia-east1-b    asia-east1-b    1.6.2           XXX.XXX.XXX.XXX  n1-standard-1  1.6.2         3          RUNNING
europe-west1-b  europe-west1-b  1.6.2           XXX.XXX.XX.X     n1-standard-1  1.6.2         3          RUNNING
us-central1-b   us-central1-b   1.6.2           XXX.XXX.XXX.XX   n1-standard-1  1.6.2         3          RUNNING
us-east1-b      us-east1-b      1.6.2           XXX.XXX.XXX.XX   n1-standard-1  1.6.2         3          RUNNING
```
