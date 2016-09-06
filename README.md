# Federated Kubernetes Tutorial

This tutorial will walk you through testing Kubernetes cluster federation. This guide will cover the following federation features:

* Federated Services
* Federated Secrets
* Federated ReplicaSets

See the [Kubernetes Cluster Federation aka Ubernetes design doc](https://github.com/kubernetes/kubernetes/blob/release-1.3/docs/design/federated-services.md) for more details.

## Prerequisites

### Clone This Repository

First checkout this repository which contains the Kubernetes configs required to build the federated control plane.

```
git clone https://github.com/kelseyhightower/kubernetes-cluster-federation.git
cd kubernetes-cluster-federation
```

## Bootrapping Tasks

This tutorial will leverage GKE to create 4 Kubernetes clusters across 4 GCP regions.

* [Provision Kubernetes Clusters](labs/cluster-bootstrap.md)
* [Create Cluster Secrets and Manifests](labs/create-cluster-secrets-and-manifests.md)
* [Create GCE DNS Managed Zone](labs/cluster-dns-managed-zone.md)
* [Download an Updated Kubernetes Client](labs/download-an-updated-kubectl-client.md)

> kubectl 1.3.6 or later is required to work with a federated Kubernetes control plane.

## Provision Federated Control Plane

The federated control plane must run in a Kubernetes host cluster which has access to a set of cluster configurations and secrets for accessing them. The following labs will walk you through provisioning a federated control plane in the `us-central1` cluster.

* [Create the Federation Namespace](labs/create-federation-namespace.md)
* [Provision the Federated API Server](labs/provision-federation-apiserver.md)
* [Provision the Federated Controller Manager](labs/provision-federation-controller-manager.md)
* [Adding Clusters to the Federation](labs/adding-clusters.md)

## Running Federated Workloads

* [Federated NGINX Service](labs/federated-nginx-service.md)
* [Federated Secrets](labs/federated-secrets.md)

## Cleaning Up

* [Delete Federated Cluster](labs/cleaning-up.md)
