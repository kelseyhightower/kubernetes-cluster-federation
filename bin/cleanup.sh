#/bin/bash

kubectl --context=federation-cluster delete clusters \
  gce-asia-east1 gce-europe-west1 gce-us-central1 gce-us-east1

kubectl --context=federation-cluster delete services nginx

kubectl --namespace=federation delete pods,svc,rc,deployment,secret --all

gcloud dns managed-zones delete federation -q

gcloud container clusters delete gce-asia-east1 -q --zone=asia-east1-b
gcloud container clusters delete gce-europe-west1 -q --zone=europe-west1-b
gcloud container clusters delete gce-us-central1 -q --zone=us-central1-b
gcloud container clusters delete gce-us-east1 -q --zone=us-east1-b
