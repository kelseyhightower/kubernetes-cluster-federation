# Download an updated kubectl Client

This guide will walk you through downloading an updated kubectl client. kubectl version 1.3.0+ is required to work with a Federated Kubernetes control plane.

### Darwin
```
curl -O https://storage.googleapis.com/kubernetes-release/release/v1.3.6/bin/darwin/amd64/kubectl
chmod a+x kubectl
sudo cp kubectl /usr/local/bin/kubectl
```

### Linux

```
curl -O https://storage.googleapis.com/kubernetes-release/release/v1.3.6/bin/linux/amd64/kubectl
chmod a+x kubectl
sudo cp kubectl /usr/local/bin/kubectl
```

### Verify

```
/usr/local/bin/kubectl version
```
```
Client Version: version.Info{Major:"1", Minor:"3", GitVersion:"v1.3.6", GitCommit:"ae4550cc9c89a593bcda6678df201db1b208133b", GitTreeState:"clean", BuildDate:"2016-08-26T18:13:23Z", GoVersion:"go1.6.2", Compiler:"gc", Platform:"darwin/amd64"}
Server Version: version.Info{Major:"1", Minor:"3", GitVersion:"v1.3.6", GitCommit:"ae4550cc9c89a593bcda6678df201db1b208133b", GitTreeState:"clean", BuildDate:"2016-08-26T18:06:06Z", GoVersion:"go1.6.2", Compiler:"gc", Platform:"linux/amd64"}
```
