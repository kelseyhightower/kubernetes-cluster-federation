# Provision Federated API Server

The Federated API Server will run in the us-central1 cluster.

The federated controller manager must be able to locate the federated API server when running on the host cluster.

## Prerequisites

### Store the GCP Project Name

```
export GCP_PROJECT=$(gcloud config list --format='value(core.project)')
```

## Create the Federated API Server Service

```
kubectl --context="gke_${GCP_PROJECT}_us-central1-b_gce-us-central1" \
  create -f services/federation-apiserver.yaml
```

Wait until the `EXTERNAL-IP` is populated as it will be required to configure the federation-controller-manager.

```
kubectl --context="gke_${GCP_PROJECT}_us-central1-b_gce-us-central1" \
  --namespace=federation \
  get services 
```
```
NAME                   CLUSTER-IP      EXTERNAL-IP    PORT(S)   AGE
federation-apiserver   10.119.242.80   XX.XXX.XX.XX   443/TCP   1m
```

## Create the Federation API Server Secret

In this section you will create a set of credentials to limit access to the federated API server.

Edit known-tokens.csv to add a token to the first column of the first line. This token will be used to authenticate Kubernetes clients.

```
XXXXXXXXXXXXXXXXXXX,admin,admin
```

### Create the federation-apiserver-secrets

Store the `known-tokens.csv` file in a Kubernetes secret that will be accessed by the federated API server at deployment time.

```
kubectl --context="gke_${GCP_PROJECT}_us-central1-b_gce-us-central1" \
  --namespace=federation \
  create secret generic federation-apiserver-secrets --from-file=known-tokens.csv
```

```
kubectl --context="gke_${GCP_PROJECT}_us-central1-b_gce-us-central1" \
  --namespace=federation \
  describe secrets federation-apiserver-secrets
```

## Federation API Server Deployment

### Create a Persistent Volume Claim

The Federated API Server leverages etcd to store cluster configuration and should be backed by a persistent disk. For production setups consider moving etcd into its own deployment.

Create a persistent disk for the federated API server:

```
kubectl --context="gke_${GCP_PROJECT}_us-central1-b_gce-us-central1" \
  --namespace=federation \
  create -f pvc/federation-apiserver-etcd.yaml
```

#### Verify

```
kubectl --context="gke_${GCP_PROJECT}_us-central1-b_gce-us-central1" \
  --namespace=federation \
  get pvc
```
```
NAME                        STATUS    VOLUME                                     CAPACITY   ACCESSMODES   AGE
federation-apiserver-etcd   Bound     pvc-c49027d3-7099-11e6-848d-42010af00158   10Gi       RWO           5s
```
```
kubectl --context="gke_${GCP_PROJECT}_us-central1-b_gce-us-central1" \
  --namespace=federation \
  get pv
```
```
NAME                                       CAPACITY   ACCESSMODES   STATUS    CLAIM                                  REASON    AGE
pvc-c49027d3-7099-11e6-848d-42010af00158   10Gi       RWO           Bound     federation/federation-apiserver-etcd             8s
```

### Create the Deployment

Get the federated API server public IP address.

```
FEDERATED_API_SERVER_ADDRESS=$(kubectl --context="gke_${GCP_PROJECT}_us-central1-b_gce-us-central1" \
  --namespace=federation \
  get services federation-apiserver \
  -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
```

Edit `deployments/federation-apiserver.yaml` and set the advertise address for the federated API server.

```
sed -i "" "s|ADVERTISE_ADDRESS|${FEDERATED_API_SERVER_ADDRESS}|g" deployments/federation-apiserver.yaml
```

Create the federated API server in the host cluster:

```
kubectl --context="gke_${GCP_PROJECT}_us-central1-b_gce-us-central1" \
  --namespace=federation \
  create -f deployments/federation-apiserver.yaml
```

### Verify

```
kubectl --context="gke_${GCP_PROJECT}_us-central1-b_gce-us-central1" \
  --namespace=federation \
  get deployments
```
```
NAME                   DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
federation-apiserver   1         1         1            0           7s
```

```
kubectl --context="gke_${GCP_PROJECT}_us-central1-b_gce-us-central1" \
  --namespace=federation \
  get pods
```
```
NAME                                   READY     STATUS    RESTARTS   AGE
federation-apiserver-116423504-4mwe8   2/2       Running   0          13s
```
