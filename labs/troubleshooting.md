# Troubleshooting Guide

```
kubectl --namespace=federation get pods
```

```
NAME                                             READY     STATUS    RESTARTS   AGE
federation-apiserver-454060463-ketpg             2/2       Running   0          14h
federation-controller-manager-3105960597-svs7u   1/1       Running   0          14h
```

```
kubectl --namespace=federation logs federation-controller-manager-3105960597-svs7u
```
