# Cluster Bootstrap

This tutorial will walk you through setting up Kubernetes clusters in 4 GCP regions using GKE.

## Create Clusters

Use the `gcloud container clusters create` command to create a Kubernetes clusters in the following zones:

* asia-east1-b
* europe-west1-b
* us-east1-b
* us-central1-b 

Run the following commands in a different tab to build the clusters in parallel.

```
gcloud container clusters create gce-asia-east1 \
  --scopes cloud-platform \
  --zone asia-east1-b
```
```
gcloud container clusters create gce-europe-west1 \
  --scopes cloud-platform \
  --zone=europe-west1-b
```
```
gcloud container clusters create gce-us-east1 \
  --scopes cloud-platform \
  --zone=us-east1-b
```
```
gcloud container clusters create gce-us-central1 \
  --scopes cloud-platform \
  --zone=us-central1-b
```

### Verify

At this point you should have 4 Kubernetes clusters running across 4 GCP regions.

```
gcloud container clusters list
```

```
NAME              ZONE            MASTER_VERSION  MASTER_IP       NUM_NODES  STATUS
gce-asia-east1    asia-east1-b    1.2.4           104.XXX.XXX.XXX 3          RUNNING
gce-europe-west1  europe-west1-b  1.2.4           130.XXX.XX.XX   3          RUNNING
gce-us-central1   us-central1-b   1.2.4           104.XXX.XXX.XX  3          RUNNING
gce-us-east1      us-east1-b      1.2.4           104.XXX.XX.XXX  3          RUNNING
```
