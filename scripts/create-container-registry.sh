#!/bin/sh

RESOURCE_GROUP_NAME = "storage-resource-group"
CONTAINER_REGISTRY_NAME = "containerregistrylinus"
AKS_CLUSTER_NAME = "akslinus"

# create resource group
az group create -n $AKS_RESOURCE_GROUP -l $AKS_LOCATION

# create container registry
az aks create -n $AKS_CLUSTER_NAME -g $AKS_RESOURCE_GROUP --generate-ssh-keys --attach-acr $ACR_NAME