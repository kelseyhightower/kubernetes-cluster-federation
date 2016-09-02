# Federated Kubernetes Tutorial

This guide will walk you through testing the upcoming support for cluster federation in Kubernetes 1.3. This guide will cover the cross-cluster load balancing and service discovery features as documented in the [Kubernetes Cluster Federation aka Ubernetes design doc](https://github.com/kubernetes/kubernetes/blob/release-1.3/docs/design/federated-services.md) 

## Prerequisites

### Clone This Repository

Frist checkout this repostory which contains the Kubernetes configs required to build the federated control plane.

```
git clone https://github.com/kelseyhightower/kubernetes-cluster-federation.git
cd kubernetes-cluster-federation
```

### Bootrapping Tasks

Next complete each of the following tasks in order.

* [Provision Kubernetes Clusters](labs/cluster-bootstrap.md)
* [Create Cluster Secrets and Manifests](labs/create-cluster-secrets-and-manifests.md)
* [Create GCE DNS Managed Zone](labs/cluster-dns-managed-zone.md)
* [Download an Updated Kubernetes](labs/download-an-updated-kubectl-client.md)

> kubectl 1.3.0 or later is required to work with a federated Kubernetes control plane.

## Provision Federated Control Plane

The Kubernetes federated control plane consists of two services:

* federation-apiserver
* federation-controller-manager

List all contexts in your local kubeconfig:

```
for c in $(kubectl config view -o jsonpath='{.contexts[*].name}'); do echo $c; done
```

Both services need to run in a host Kubernetes cluster. Use the gce-us-central1 cluster as the host cluster.

```
kubectl config use-context gke_hightowerlabs_us-central1-b_gce-us-central1
```

> Your context names will be different. Replace hightowerlabs with your GCP project name. 

## Provision Federated Kubernetes Cluster

* [Create the Federation Namespace](labs/create-federation-namespace.md)
* [Provision the Federated API Server](labs/provision-federation-apiserver.md)
* [Provision the Federated Controller Manager](labs/provision-federation-controller-manager.md)
* [Adding Clusters to the Federation](labs/adding-clusters.md)

## Running Federated Workloads

* [Federated Services](labs/federated-services.md)

## Cleaning Up

* [Delete Federated Cluster](labs/cleaning-up.md)
