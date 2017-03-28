# Provision Federated Controller Manager

## Prerequisites

```
kubectl config use-context host-cluster
```

### Create the Federation API Sever Secret Token

The Federation API Sever token was created in the previous lab.

* [Create the Federation API Sever Secret Token](provision-federation-apiserver.md#create-the-federation-api-server-secret)

## Create the Federated API Server Kubeconfig

The federation-controller-manager needs a kubeconfig file to connect to the federation-apiserver.

Use the `kubectl config` command to build up a kubeconfig file for the federated API server:

```
kubectl config set-cluster federation-cluster \
  --server=https://$(kubectl get services federation-apiserver \
    -o jsonpath='{.status.loadBalancer.ingress[0].ip}') \
  --insecure-skip-tls-verify=true
```

Get the token from the `known-tokens.csv` file:

```
FEDERATION_TOKEN=$(cut -d"," -f1 known-tokens.csv)
```

```
kubectl config set-credentials federation-cluster \
  --token=${FEDERATION_TOKEN}
```

```
kubectl config set-context federation-cluster \
  --cluster=federation-cluster \
  --user=federation-cluster
```

Switch to the `federation-cluster` context and dump the federated API server credentials:

```
kubectl config use-context federation-cluster
```

```
mkdir -p kubeconfigs/federation-apiserver
```

```
kubectl config view --flatten --minify > kubeconfigs/federation-apiserver/kubeconfig
```

#### Create the Federated API Server Secret

Switch to the host cluster context and create the `federation-apiserver-kubeconfig`, which holds the kubeconfig for the federated API server used by the Federated Controller Manager.

```
kubectl config use-context host-cluster
```

```
kubectl create secret generic federation-apiserver-kubeconfig \
  --from-file=kubeconfigs/federation-apiserver/kubeconfig
```

Verify

```
kubectl describe secrets federation-apiserver-kubeconfig
```

### Deploy the Federated Controller Manager

```
DNS_ZONE_NAME=$(gcloud dns managed-zones describe federation --format='value(dnsName)')
```

```
DNS_ZONE_ID=$(gcloud dns managed-zones describe federation --format='value(id)')
```

```
kubectl create configmap federation-controller-manager \
  --from-literal=zone-id=${DNS_ZONE_ID} \
  --from-literal=zone-name=${DNS_ZONE_NAME}
```

```
kubectl get configmap federation-controller-manager -o yaml
```

```
kubectl create -f deployments/federation-controller-manager.yaml
```

Wait for the `federation-controller-manager` pod to be running.

```
kubectl get pods
```

### Configure kube-dns with federated DNS support

In order for automatic DNS failover to work kube-dns must be configured to support federation.

```
kubectl config use-context federation-cluster
```

```
mkdir -p configmaps
```

```
cat > configmaps/kube-dns.yaml <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: kube-dns
  namespace: kube-system
data:
  federations: federation=${DNS_ZONE_NAME}
EOF
```

```
kubectl create -f configmaps/kube-dns.yaml 
```


