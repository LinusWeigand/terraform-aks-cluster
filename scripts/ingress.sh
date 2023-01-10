#!/bin/sh

# set context
az aks get-credentials --resource-group linus-rg --name linusaks --admin

# Deploy in cluster
kubectl apply -f ingress.yaml