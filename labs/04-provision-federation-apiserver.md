# Provision Federated API Server

The Federated API Server will run in the us-central1 cluster.

The federated controller manager must be able to locate the federated API server when running on the host cluster.

## Prerequisites

```
kubectl config use-context host-cluster
```

## Create the Federation Namespace

The Kubernetes federation control plane will run in the federation namespace. Create the federation namespace using kubectl:

```
kubectl create -f ns/federation.yaml
```

## Create the Federated API Server Service

```
kubectl create -f services/federation-apiserver.yaml
```

Wait until the `EXTERNAL-IP` is populated as it will be required to configure the federation-controller-manager.

```
kubectl get services 
```

```
NAME                   CLUSTER-IP      EXTERNAL-IP    PORT(S)   AGE
federation-apiserver   XX.XXX.XXX.XX   XX.XXX.XX.XX   443/TCP   1m
```

## Create the Federation API Server Secret

In this section you will create a set of credentials to limit access to the federated API server.

```
FEDERATION_TOKEN=$(head -c 16 /dev/urandom | od -An -t x | tr -d ' ')
```

```
cat > known-tokens.csv <<EOF
${FEDERATION_TOKEN},admin,admin
EOF
```

### Create the federation-apiserver-secrets

Store the `known-tokens.csv` file in a Kubernetes secret that will be accessed by the federated API server at deployment time.

```
kubectl create secret generic federation-apiserver-secrets \
  --from-file=known-tokens.csv
```

```
kubectl describe secrets federation-apiserver-secrets
```

## Federation API Server Deployment

### Create a Persistent Volume Claim

The Federated API Server leverages etcd to store cluster configuration and should be backed by a persistent disk. For production setups consider moving etcd into its own deployment.

Create a persistent disk for the federated API server:

```
kubectl create -f pvc/federation-apiserver-etcd.yaml
```

#### Verify

```
kubectl get pvc
```

```
kubectl get pv
```

### Create the Deployment

Create the `federated-apiserver` configmap:

```
kubectl create configmap federated-apiserver \
  --from-literal=advertise-address=$(kubectl \
    get services federation-apiserver \
    -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
```

```
kubectl get configmap federated-apiserver \
  -o jsonpath='{.data.advertise-address}'
```

Create the federated API server:

```
kubectl create -f deployments/federation-apiserver.yaml
```

### Verify

```
kubectl get deployments
```

```
kubectl get pods
```
