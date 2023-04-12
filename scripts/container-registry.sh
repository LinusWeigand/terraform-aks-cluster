#!/bin/sh

CONTAINER_RESOURCE_GROUP="container-resource-group"
CONTAINER_REGISTRY_NAME="linuscontainerregistry"
CLUSTER="linusaks"

# create resource group
az group create -n $CONTAINER_RESOURCE_GROUP 

# create container registry
az acr create -n $CONTAINER_REGISTRY_NAME -g $CONTAINER_RESOURCE_GROUP --sku Basic

# attach to aks cluster
az aks update -n $CLUSTER --attach-acr $CONTAINER_REGISTRY_NAME
