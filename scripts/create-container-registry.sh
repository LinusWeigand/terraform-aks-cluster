#!/bin/sh

RESOURCE_GROUP_NAME="linus-rg"
CONTAINER_REGISTRY_NAME="linuscontainerregistry2"
AKS_CLUSTER_NAME="linusaks"
LOCATION="germanywestcentral"

# create resource group
# az group create -n $RESOURCE_GROUP_NAME -l $LOCATION

# create container registry
az acr create -n $CONTAINER_REGISTRY_NAME -g $RESOURCE_GROUP_NAME --sku Basic

# attach to aks cluster
az aks update -n $AKS_CLUSTER_NAME -g $RESOURCE_GROUP_NAME --attach-acr $CONTAINER_REGISTRY_NAME

# push image to container registry
az acr login --name $CONTAINER_REGISTRY_NAME

docker push linuscontainerregistry2.azurecr.io/create-react-app:1.0.0