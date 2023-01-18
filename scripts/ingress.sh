#!/bin/sh

# set context
az aks get-credentials --resource-group linus-rg --name linusaks --admin --overwrite-existing

# Deploy in cluster
kubectl apply -f ingress.yaml