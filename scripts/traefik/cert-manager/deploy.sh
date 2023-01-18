#!/bin/sh

helm create namepspace cert-manager

kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.9.1/cert-manager.crds.yaml

helm install cert-manager jetstack/cert-manager --namespace cert-manager --values=values --version v1.9.1

# helm install cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace --set installCRDs=true