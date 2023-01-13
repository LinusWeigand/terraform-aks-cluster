#!/bin/sh

# Package chart
# helm package .

# Log into ACR
az acr login --name linuscontainerregistry2

# Push Chart to ACR
helm push my-chart-0.1.0.tgz oci://linuscontainerregistry2.azurecr.io/helm 

# Install Chart from ACR
helm install my-chart oci://linuscontainerregistry2.azurecr.io/helm/my-chart --version 0.1.0