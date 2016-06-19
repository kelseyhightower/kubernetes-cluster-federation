# Download an updated kubectl Client

This guide will walk you through downloading an updated kubectl client. kubectl version 1.3.0+ is required to work with a Federated Kubernetes control plane.

```
wget https://github.com/kubernetes/kubernetes/releases/download/v1.3.0-beta.1/kubernetes.tar.gz
tar -xvf kubernetes.tar.gz
```

### Darwin

```
sudo cp kubernetes/platforms/darwin/amd64/kubectl /usr/local/bin/kubectl
```

### Linux

```
sudo cp kubernetes/platforms/linux/amd64/kubectl /usr/local/bin/kubectl
```

### Verify

```
/usr/local/bin/kubectl version
```
```
Client Version: version.Info{Major:"1", Minor:"3+", GitVersion:"v1.3.0-beta.1", GitCommit:"1c7855093eb999c8f3cedb19d3467cd7b691e35e", GitTreeState:"clean", BuildDate:"2016-06-17T00:58:51Z", GoVersion:"go1.6.2", Compiler:"gc", Platform:"darwin/amd64"}
Server Version: version.Info{Major:"1", Minor:"2", GitVersion:"v1.2.4", GitCommit:"3eed1e3be6848b877ff80a93da3785d9034d0a4f", GitTreeState:"clean", BuildDate:"", GoVersion:"", Compiler:"", Platform:""}
```
