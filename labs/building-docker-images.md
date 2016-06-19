# Federated Cluster Images

The following tutorial will result in the following docker images hosted on the Docker Hub.

* kelseyhightower/federation-apiserver:a03b7405e5c8f09629c5a50f15641fed
* kelseyhightower/federation-controller-manager:c714637c56cdd3e8c0d410b258fbe357

## Download the Kubernetes 1.3 Beta Release

```
wget https://github.com/kubernetes/kubernetes/releases/download/v1.3.0-beta.1/kubernetes.tar.gz
tar -xvf kubernetes.tar.gz
cd kubernetes.tar.gz
```

Extract the Linux build artificats

```
tar -xvf server/kubernetes-server-linux-amd64.tar.gz
```

## Create the Docker Images

### Federated APIServer

```
docker load < kubernetes/server/bin/federation-apiserver.tar
```

```
docker tag gcr.io/google_containers/federation-apiserver:a03b7405e5c8f09629c5a50f15641fed \
  kelseyhightower/federation-apiserver:a03b7405e5c8f09629c5a50f15641fed
```

```
docker push kelseyhightower/federation-apiserver:a03b7405e5c8f09629c5a50f15641fed
```

### Federated Controller Manager

```
docker load < kubernetes/server/bin/federation-controller-manager.tar
```

```
docker tag gcr.io/google_containers/federation-controller-manager:c714637c56cdd3e8c0d410b258fbe357 \
  kelseyhightower/federation-controller-manager:c714637c56cdd3e8c0d410b258fbe357
```

```
docker push kelseyhightower/federation-controller-manager:c714637c56cdd3e8c0d410b258fbe357
```
