# Download an updated kubectl Client

This guide will walk you through downloading an updated kubectl client. kubectl version 1.6.1+ is required to work with a Federated Kubernetes control plane.

### Darwin
```
curl -O https://storage.googleapis.com/kubernetes-release/release/v1.6.2/bin/darwin/amd64/kubectl
chmod a+x kubectl
sudo cp kubectl /usr/local/bin/kubectl
```

### Linux

```
curl -O https://storage.googleapis.com/kubernetes-release/release/v1.6.2/bin/linux/amd64/kubectl
chmod a+x kubectl
sudo cp kubectl /usr/local/bin/kubectl
```

### Verify

```
/usr/local/bin/kubectl version
```
