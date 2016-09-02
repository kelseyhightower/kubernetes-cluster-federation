# Federated NGINX Service

This lab will walk you through creating a federated NGINX service backed by the following federated objects:

* replicaset - to ensure the nginx pod runs 
* service

## Federated NGINX ReplicaSet

```
kubectl --context=federation-cluster create -f rs/nginx.yaml
```

### Verify

```
kubectl --context=federation-cluster get rs
```
```
NAME      DESIRED   CURRENT   AGE
nginx     4         0         13m
```

### List Pods

#### gce-us-central1

```
kubectl --context="gke_${GCP_PROJECT}_us-central1-b_gce-us-central1" get pods
```
```
NAME          READY     STATUS    RESTARTS   AGE
nginx-z5wkd   1/1       Running   0          3m
```

#### gce-asia-east1

```
kubectl --context="gke_${GCP_PROJECT}_asia-east1-b_gce-asia-east1" get pods
```
```
NAME          READY     STATUS    RESTARTS   AGE
nginx-5zbg4   1/1       Running   0          4m
```

#### gce-europe-west1

```
kubectl --context="gke_${GCP_PROJECT}_europe-west1-b_gce-europe-west1" get pods
```
```
NAME          READY     STATUS    RESTARTS   AGE
nginx-eavl4   1/1       Running   0          5m
```

#### gce-us-east1

```
kubectl --context="gke_${GCP_PROJECT}_us-east1-b_gce-us-east1" get pods
```
```
NAME          READY     STATUS    RESTARTS   AGE
nginx-lovnq   1/1       Running   0          6m
```

## Federated NGINX Service

Create a federated service object in the `federation-cluster` context.

```
kubectl --context=federation-cluster create -f services/nginx.yaml
```

Wait until the nginx service is propagated across all 4 clusters and the federated service is updated with the details. Currently this can take up to 5 mins to complete.

### Verify

```
kubectl --context=federation-cluster describe services nginx
```
```
Name:                   nginx
Namespace:              default
Labels:                 run=nginx
Selector:               run=nginx
Type:                   LoadBalancer
IP:			
LoadBalancer Ingress:   104.197.246.190, 130.211.57.243, 104.196.14.231, 104.199.136.89
Port:                   http    80/TCP
Endpoints:		        <none>
Session Affinity:	    None
No events.
```

List all contexts in your local kubeconfig

```
for c in $(kubectl config view -o jsonpath='{.contexts[*].name}'); do echo $c; done
```

View the nginx service in each Kubernetes cluster, which was created by the federated controller manager.

```
kubectl --context=gke_hightowerlabs_asia-east1-b_gce-asia-east1 get svc nginx
```
```
NAME      CLUSTER-IP     EXTERNAL-IP      PORT(S)   AGE
nginx     10.63.250.98   104.199.136.89   80/TCP    9m
```

### Create Nginx Deployments

```
kubectl --context="gke_hightowerlabs_asia-east1-b_gce-asia-east1" \
  run nginx --image=nginx:1.11.1-alpine --port=80
```

```
kubectl --context="gke_hightowerlabs_europe-west1-b_gce-europe-west1" \
  run nginx --image=nginx:1.11.1-alpine --port=80
```

```
kubectl --context=gke_hightowerlabs_us-central1-b_gce-us-central1 \
  run nginx --image=nginx:1.11.1-alpine --port=80
```

```
kubectl --context="gke_hightowerlabs_us-east1-b_gce-us-east1" \
  run nginx --image=nginx:1.11.1-alpine --port=80
```

### Review Cloud DNS Console

The Federated controller manager creates DNS entires in the configured zone.

![Google Cloud DNS](images/googledns.png)


