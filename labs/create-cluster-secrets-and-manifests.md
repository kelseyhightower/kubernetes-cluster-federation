# Create Cluster Secrets and Manifests

### Setup Cluster Configurations

The are two configuration files needed for each cluster in the federation.

* cluster config
* kubeconfig

#### Configuring kubeconfig

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

#### gce-asia-east1

```
kubectl config use-context gke_hightowerlabs_asia-east1-b_gce-asia-east1
```
```
serverAddress=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')
```
```
sed -i "" "s|SERVER_ADDRESS|${serverAddress}|g" clusters/gce-asia-east1.yaml
```
```
kubectl config view --flatten --minify > kubeconfigs/gce-asia-east1/kubeconfig
```

#### gce-europe-west1

```
kubectl config use-context gke_hightowerlabs_europe-west1-b_gce-europe-west1
```
```
serverAddress=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')
```
```
sed -i "" "s|SERVER_ADDRESS|${serverAddress}|g" clusters/gce-europe-west1.yaml
```
```
kubectl config view --flatten --minify > kubeconfigs/gce-europe-west1/kubeconfig
```

#### gce-us-central1

```
kubectl config use-context gke_hightowerlabs_us-central1-b_gce-us-central1
```
```
serverAddress=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')
```
```
sed -i "" "s|SERVER_ADDRESS|${serverAddress}|g" clusters/gce-us-central1.yaml
```
```
kubectl config view --flatten --minify > kubeconfigs/gce-us-central1/kubeconfig
```

#### gce-us-east1

```
kubectl config use-context gke_hightowerlabs_us-east1-b_gce-us-east1
```
```
serverAddress=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')
```
```
sed -i "" "s|SERVER_ADDRESS|${serverAddress}|g" clusters/gce-us-east1.yaml
```
```
kubectl config view --flatten --minify > kubeconfigs/gce-us-east1/kubeconfig
```

