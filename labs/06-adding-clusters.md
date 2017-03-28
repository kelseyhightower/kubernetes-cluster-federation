# Adding Clusters

With the federated control plane in place we are ready to start adding clusters to our federation.

To add a cluster to the federation you will need to perform the following steps:

* Create kubeconfig for each cluster and store it in a Kubernetes secret on the host cluster
* Create a cluster resource for each cluster in the federation cluster

## Prerequisites

```
kubectl config use-context host-cluster
```

```
CLUSTERS="asia-east1-b europe-west1-b us-east1-b us-central1-b"
```

### Generate kubeconfigs and cluster objects

In this section you will generate a kubeconfig and cluster resource object for each cluster in the federation.

```
mkdir clusters
```

```
mkdir -p kubeconfigs
```

```
for cluster in ${CLUSTERS}; do
  mkdir -p kubeconfigs/${cluster}/

  SERVER=$(gcloud container clusters describe ${cluster} \
    --zone ${cluster} \
    --format 'value(endpoint)')

  CERTIFICATE_AUTHORITY_DATA=$(gcloud container clusters describe ${cluster} \
    --zone ${cluster} \
    --format 'value(masterAuth.clusterCaCertificate)')

  CLIENT_CERTIFICATE_DATA=$(gcloud container clusters describe ${cluster} \
    --zone ${cluster} \
    --format 'value(masterAuth.clientCertificate)')

  CLIENT_KEY_DATA=$(gcloud container clusters describe ${cluster} \
    --zone ${cluster} \
    --format 'value(masterAuth.clientKey)')

  kubectl config set-cluster ${cluster} --kubeconfig kubeconfigs/${cluster}/kubeconfig

  kubectl config set clusters.${cluster}.server \
    "https://${SERVER}" \
    --kubeconfig kubeconfigs/${cluster}/kubeconfig

  kubectl config set clusters.${cluster}.certificate-authority-data \
    ${CERTIFICATE_AUTHORITY_DATA} \
    --kubeconfig kubeconfigs/${cluster}/kubeconfig

  kubectl config set-credentials admin --kubeconfig kubeconfigs/${cluster}/kubeconfig

  kubectl config set users.admin.client-certificate-data \
    ${CLIENT_CERTIFICATE_DATA} \
    --kubeconfig kubeconfigs/${cluster}/kubeconfig

  kubectl config set users.admin.client-key-data \
    ${CLIENT_KEY_DATA} \
    --kubeconfig kubeconfigs/${cluster}/kubeconfig

  kubectl config set-context default \
    --cluster=${cluster} \
    --user=admin \
    --kubeconfig kubeconfigs/${cluster}/kubeconfig

  kubectl config use-context default \
    --kubeconfig kubeconfigs/${cluster}/kubeconfig

  cat > clusters/${cluster}.yaml <<EOF
apiVersion: federation/v1beta1
kind: Cluster
metadata:
  name: ${cluster}
spec:
  serverAddressByClientCIDRs:
    - clientCIDR: "0.0.0.0/0"
      serverAddress: "https://${SERVER}"
  secretRef:
    name: ${cluster}
EOF
done
```

## Create the Cluster Secrets

In this section you will create a secret to hold the kubeconfig for each cluster. 

```
for cluster in ${CLUSTERS}; do
  kubectl create secret generic ${cluster} \
    --from-file=kubeconfigs/${cluster}/kubeconfig
done
```

## Create the cluster resources

```
kubectl config use-context federation-cluster
```

```
kubectl create -f clusters/
```

### Verify

```
kubectl get clusters
```

```
NAME             STATUS    AGE
asia-east1-b     Ready     46s
europe-west1-b   Ready     45s
us-central1-b    Ready     44s
us-east1-b       Ready     43s
```
