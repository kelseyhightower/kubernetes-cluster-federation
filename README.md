# Kubernetes Cluster Federation Tutorial

This tutorial will walk you through setting up a Kubernetes cluster federation composed of four Kubernetes clusters across multiple GCP regions.

## Prerequisites

### Clone This Repository

Checkout this repository which contains the Kubernetes configs required to provision a federated control plane.

```
git clone https://github.com/kelseyhightower/kubernetes-cluster-federation.git
```

```
cd kubernetes-cluster-federation
```

## Bootstrapping Tasks

This tutorial will leverage [Google Container Engine](https://cloud.google.com/container-engine) to provision four Kubernetes clusters across multiple GCP regions.

* [Provision Kubernetes Clusters](labs/01-cluster-bootstrap.md)
* [Create GCE DNS Managed Zone](labs/02-cluster-dns-managed-zone.md)
* [Download an Updated Kubernetes Client](labs/03-download-an-updated-kubectl-client.md)

## Provision Federated Control Plane

The federated control plane must run in a Kubernetes host cluster which has access to a set of cluster configurations and secrets for accessing them. The following labs will walk you through provisioning a federated control plane in the `us-central1` cluster.

* [Provision the Federated API Server](labs/04-provision-federation-apiserver.md)
* [Provision the Federated Controller Manager](labs/05-provision-federation-controller-manager.md)
* [Adding Clusters to the Federation](labs/06-adding-clusters.md)

## Running Federated Workloads

* [Federated NGINX Service](labs/07-federated-nginx-service.md)
* [Federated Secrets](labs/08-federated-secrets.md)

## Cleaning Up

* [Delete Federated Cluster](labs/09-cleaning-up.md)
