# Create Cluster Secrets and Manifests

## Setup Cluster Configurations

There are two configuration files needed for each cluster to join them to a federation.

* cluster config
* kubeconfig

The `cluster config` is a Kubernetes cluster object and holds information required by the Kubernetes Federated Controller Manager to add a cluster to a federation.

The `kubeconfig` file is a standard Kubernetes configuration object that is used to provide API Server credentials to Kubernetes clients. You will need one `kubeconfig` file for each cluster in the federation.

### Configuring kubeconfig

Get credentials for each Kubernetes cluster:

```
gcloud container clusters get-credentials gce-asia-east1 --zone=asia-east1-b
gcloud container clusters get-credentials gce-europe-west1 --zone=europe-west1-b
gcloud container clusters get-credentials gce-us-east1 --zone=us-east1-b
gcloud container clusters get-credentials gce-us-central1 --zone=us-central1-b
```

List the contexts stored in your local kubeconfig:

```
for c in $(kubectl config view -o jsonpath='{.contexts[*].name}'); do echo $c; done
```

```
gke_hightowerlabs_asia-east1-b_gce-asia-east1
gke_hightowerlabs_europe-west1-b_gce-europe-west1
gke_hightowerlabs_us-central1-b_gce-us-central1
gke_hightowerlabs_us-east1-b_gce-us-east1
```

The names of your cluster contexts will be different based on your GCP project name:

```
gke_<project-name>_asia-east1-b_gce-asia-east1
```

### Generate Cluster Configs

For each cluster create a kubeconfig file and update the corresponding cluster manifest:

#### gce-asia-east1

```
kubectl config use-context gke_hightowerlabs_asia-east1-b_gce-asia-east1
serverAddress=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')
sed -i "s|SERVER_ADDRESS|${serverAddress}|g" clusters/gce-asia-east1.yaml
kubectl config view --flatten --minify > kubeconfigs/gce-asia-east1/kubeconfig
```

#### gce-europe-west1

```
kubectl config use-context gke_hightowerlabs_europe-west1-b_gce-europe-west1
serverAddress=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')
sed -i "s|SERVER_ADDRESS|${serverAddress}|g" clusters/gce-europe-west1.yaml
kubectl config view --flatten --minify > kubeconfigs/gce-europe-west1/kubeconfig
```

#### gce-us-central1

```
kubectl config use-context gke_hightowerlabs_us-central1-b_gce-us-central1
serverAddress=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')
sed -i "s|SERVER_ADDRESS|${serverAddress}|g" clusters/gce-us-central1.yaml
kubectl config view --flatten --minify > kubeconfigs/gce-us-central1/kubeconfig
```

#### gce-us-east1

```
kubectl config use-context gke_hightowerlabs_us-east1-b_gce-us-east1
serverAddress=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')
sed -i "s|SERVER_ADDRESS|${serverAddress}|g" clusters/gce-us-east1.yaml
kubectl config view --flatten --minify > kubeconfigs/gce-us-east1/kubeconfig
```

