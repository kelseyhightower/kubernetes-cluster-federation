# Federated Secrets

Kubernetes supports the federation of secrets across multiple clusters. Federated secrets are automatically created on new clusters added to the federation.

## Prerequisites

### Store the GCP Project Name

```
export GCP_PROJECT=$(gcloud config list --format='value(core.project)')
```

## Federate Secrets

The following command will create the `federated` secret across all 4 clusters:

```
kubectl --context=federation-cluster create secret generic federated --from-literal=password=foo
```
```
secret "federated" created
```

### Verify

List the cluster level secrets for the following cluster contexts:

* gke_${GCP_PROJECT}_asia-east1-b_gce-asia-east1
* gke_${GCP_PROJECT}_europe-west1-b_gce-europe-west1
* gke_${GCP_PROJECT}_us-east1-b_gce-us-east1
* gke_${GCP_PROJECT}_us-central1-b_gce-us-central1

#### Example

List the `federated` secret

```
kubectl --context="gke_${GCP_PROJECT}_us-central1-b_gce-us-central1" \
  get secrets
```

```
NAME                  TYPE                                  DATA      AGE
default-token-ii9uy   kubernetes.io/service-account-token   3         4h
federated             Opaque                                1         1m
```

Describe the `federated` secret:

```
kubectl --context="gke_${GCP_PROJECT}_us-central1-b_gce-us-central1" \
  describe secret federated
```
```
Name:         federated
Namespace:    default
Labels:       <none>
Annotations:  <none>

Type:         Opaque

Data
====
password:     3 bytes
```
