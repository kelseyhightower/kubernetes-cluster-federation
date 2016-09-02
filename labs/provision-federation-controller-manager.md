# Provision Federated Controller Manager

## Create the Federated API Server Kubeconfig

The federation-controller-manager needs a kubeconfig file to connect to the federation-apiserver.

Get the federated API server public IP address:

```
advertiseAddress=$(kubectl --namespace=federation get services federation-apiserver \
  -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
```

Use the `kubectl config` command to build up a kubeconfig file for the federated API server:

```
kubectl config set-cluster federation-cluster \
  --server=https://${advertiseAddress} \
  --insecure-skip-tls-verify=true
```

```
kubectl config set-credentials federation-cluster \
  --token=changeme
```

> The `--token` flag must be set to the same token used in the known-tokens.csv.

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
kubectl config view --flatten --minify > kubeconfigs/federation-apiserver/kubeconfig
```

#### Create the Federated API Server Secret

Switch to the host cluster context and create the `federation-apiserver-kubeconfig`, which holds the kubeconfig for the federated API server used by the Federated Controller Manager.

```
kubectl config use-context gke_hightowerlabs_us-central1-b_gce-us-central1
```

```
kubectl create secret generic federation-apiserver-kubeconfig \
  --namespace=federation \
  --from-file=kubeconfigs/federation-apiserver/kubeconfig
```

Verify

```
kubectl --namespace=federation describe secrets federation-apiserver-kubeconfig
```

### Deploy the Federated Controller Manager

```
kubectl create -f deployments/federation-controller-manager.yaml
```

Wait for the `federation-controller-manager` pod to be running.

```
kubectl --namespace=federation get pods
```

```
NAME                                             READY     STATUS    RESTARTS   AGE
federation-apiserver-116423504-4mwe8             2/2       Running   0          12m
federation-controller-manager-1899587413-c1c1w   1/1       Running   0          16s
```
