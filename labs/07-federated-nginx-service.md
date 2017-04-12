# Federated NGINX Service

This lab will walk you through creating a federated NGINX service using replica sets and services. For more details on how federated replica sets work review the [Federated ReplicaSet Requirements & Design Document](https://docs.google.com/a/google.com/document/d/1C1HEHQ1fwWtEhyl9JYu6wOiIUJffSmFmZgkGta4720I/edit?usp=sharing)

## Prerequisites

```
kubectl config use-context federation-cluster
```

## Federated NGINX ReplicaSet

Federated replica sets leverage the same configuration as a non-federated Kubernetes clusters. By default pods created by a replica set are distributed evenly across all configured clusters.

```
kubectl get clusters
```

```
NAME             STATUS    AGE
asia-east1-b     Ready     2m
europe-west1-b   Ready     2m
us-central1-b    Ready     2m
us-east1-b       Ready     2m
```

The following command will create an nginx replica set and create 4 nginx pods.

```
kubectl create -f rs/nginx.yaml
```

### Verify

```
kubectl get rs
```

```
NAME      DESIRED   CURRENT   READY     AGE
nginx     4         4         4         33s
```

### List Pods

```
CLUSTERS="asia-east1-b europe-west1-b us-east1-b us-central1-b"
```

```
for cluster in ${CLUSTERS}; do
  echo ""
  echo "${cluster}"
  kubectl --context=${cluster} get pods
done
```

Output:

```
asia-east1-b
NAME          READY     STATUS    RESTARTS   AGE
nginx-zpdcn   1/1       Running   0          5m

europe-west1-b
NAME          READY     STATUS    RESTARTS   AGE
nginx-p8hg0   1/1       Running   0          5m

us-east1-b
NAME          READY     STATUS    RESTARTS   AGE
nginx-07ddf   1/1       Running   0          6m

us-central1-b
NAME          READY     STATUS    RESTARTS   AGE
nginx-m3vzb   1/1       Running   0          6m
```

## Federated NGINX ReplicaSet with Preferences

An annotation can be used to control which clusters pods are scheduled to.

```
apiVersion: extensions/v1beta1
kind: ReplicaSet
metadata:
  name: nginx-us
  annotations:
    federation.kubernetes.io/replica-set-preferences: |
        {
            "rebalance": true,
            "clusters": {
                "us-east1-b": {
                    "minReplicas": 2,
                    "maxReplicas": 4,
                    "weight": 1
                },
                "us-central1-b": {
                    "minReplicas": 2,
                    "maxReplicas": 4,
                    "weight": 1
                }
            }
        }
```

The following command will create pods only in the `us-east1-b` and `us-central1-b` clusters

```
kubectl create -f rs/nginx-us.yaml
```

### Verify

```
for cluster in ${CLUSTERS}; do
  echo ""
  echo "${cluster}"
  kubectl --context=${cluster} get pods
done
```

> Notice there are no `nginx-us` pods running in the `europe-west1-b` or `asia-east1-b` clusters:


## Federated NGINX Service

Create a federated service object in the `federation-cluster` context.

```
kubectl config use-context federation-cluster
```

```
kubectl create -f services/nginx.yaml
```

Wait until the nginx service is propagated across all 4 clusters and the federated service is updated with the details. Currently this can take up to 5 mins to complete.

### Verify

Describe the federated nginx service.

```
kubectl describe services nginx
```

```
Name:			nginx
Namespace:		default
Labels:			app=nginx
Selector:		app=nginx
Type:			LoadBalancer
IP:			
LoadBalancer Ingress:	104.155.179.91, 104.199.198.18, 104.196.155.68, 23.251.129.13
Port:			http	80/TCP
Endpoints:		<none>
Session Affinity:	None
No events.
```

### List Services


```
for cluster in ${CLUSTERS}; do
  echo ""
  echo "${cluster}"
  kubectl --context=${cluster} describe services nginx
done
```

```
Name:                   nginx
Namespace:              default
Labels:                 app=nginx
Selector:               app=nginx
Type:                   LoadBalancer
IP:                     10.87.255.25
LoadBalancer Ingress:   XXX.XXX.XXX.XX
Port:                   http	80/TCP
NodePort:               http	30330/TCP
Endpoints:              10.84.1.5:80
Session Affinity:       None
```


### Review Cloud DNS Console

The Federated controller manager creates DNS entries in the configured zone.

![Google Cloud DNS](images/googledns.png)


