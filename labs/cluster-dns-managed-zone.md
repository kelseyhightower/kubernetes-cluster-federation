# Cluster DNS Managed Zone

Kubernetes federated services have the ability to manage external DNS entries based on services created across a federated set of Kubernetes clusters. In this lab you will setup a [Google DNS managed zone](https://cloud.google.com/dns/zones) to hold the DNS entries. Kubernetes will support other external DNS providers using a plugin based system on the Federated Controller Manager.

## Create a Google DNS Managed Zone

The follow command will create a DNS zone named `federation.com`. In a production setup a valid managed zone backed by a registered DNS domain should be used.

```
gcloud dns managed-zones create federation \
  --description "Kubernetes federation testing" \
  --dns-name federation.com
```
