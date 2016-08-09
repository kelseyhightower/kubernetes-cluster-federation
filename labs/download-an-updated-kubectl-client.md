# Download an updated kubectl Client

This guide will walk you through downloading an updated kubectl client. kubectl version 1.3.0+ is required to work with a Federated Kubernetes control plane.

### Darwin
```
curl -O https://storage.googleapis.com/kubernetes-release/release/v1.3.0/bin/darwin/amd64/kubectl
chmod a+x kubectl
sudo cp kubectl /usr/local/bin/kubectl
```

### Linux

```
curl -O https://storage.googleapis.com/kubernetes-release/release/v1.3.0/bin/linux/amd64/kubectl
chmod a+x kubectl
sudo cp kubectl /usr/local/bin/kubectl
```

### Verify

```
/usr/local/bin/kubectl version
```
```
Client Version: version.Info{Major:"1", Minor:"3", GitVersion:"v1.3.0", GitCommit:"283137936a498aed572ee22af6774b6fb6e9fd94", GitTreeState:"clean", BuildDate:"2016-07-01T19:26:38Z", GoVersion:"go1.6.2", Compiler:"gc", Platform:"darwin/amd64"}
Server Version: version.Info{Major:"1", Minor:"2", GitVersion:"v1.2.4", GitCommit:"3eed1e3be6848b877ff80a93da3785d9034d0a4f", GitTreeState:"clean", BuildDate:"", GoVersion:"", Compiler:"", Platform:""}
```
