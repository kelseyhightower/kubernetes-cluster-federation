# Cluster Bootstrap

This tutorial will walk you through setting up Kubernetes clusters in 4 GCP regions using GKE.

## Create Clusters

Use the `gcloud container clusters create` command to create a Kubernetes clusters in the following zones:

* asia-east1-b
* europe-west1-b
* us-east1-b
* us-central1-b 

Run the following commands in a different tab to build the clusters in parallel.

### gce-asia-east1

```
gcloud container clusters create gce-asia-east1 \
  --zone asia-east1-b \
  --scopes "cloud-platform,storage-ro,logging-write,monitoring-write,service-control,service-management,https://www.googleapis.com/auth/ndev.clouddns.readwrite"
```

### gce-europe-west1

```
gcloud container clusters create gce-europe-west1 \
  --zone=europe-west1-b \
  --scopes "cloud-platform,storage-ro,logging-write,monitoring-write,service-control,service-management,https://www.googleapis.com/auth/ndev.clouddns.readwrite"
```

### gce-us-east1

```
gcloud container clusters create gce-us-east1 \
  --zone=us-east1-b \
  --scopes "cloud-platform,storage-ro,logging-write,monitoring-write,service-control,service-management,https://www.googleapis.com/auth/ndev.clouddns.readwrite"
```

### gce-us-central1

```
gcloud container clusters create gce-us-central1 \
  --zone=us-central1-b \
  --scopes "cloud-platform,storage-ro,logging-write,monitoring-write,service-control,service-management,https://www.googleapis.com/auth/ndev.clouddns.readwrite"
```

### Verify

At this point you should have 4 Kubernetes clusters running across 4 GCP regions.

```
gcloud container clusters list
```

```
NAME              ZONE            MASTER_VERSION  MASTER_IP        MACHINE_TYPE   NODE_VERSION  NUM_NODES  STATUS
gce-asia-east1    asia-east1-b    1.3.6           XXX.XXX.XXX.XXX  n1-standard-1  1.3.6         3          RUNNING
gce-europe-west1  europe-west1-b  1.3.6           XXX.XXX.XX.X     n1-standard-1  1.3.6         3          RUNNING
gce-us-central1   us-central1-b   1.3.6           XXX.XXX.XXX.XX   n1-standard-1  1.3.6         3          RUNNING
gce-us-east1      us-east1-b      1.3.6           XXX.XXX.XXX.XX   n1-standard-1  1.3.6         3          RUNNING
```
