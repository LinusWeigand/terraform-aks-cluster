#!/bin/sh
Green='\033[0;32m'
NC='\033[0m'


CLUSTER_GROUP_NAME="linus-rg"
CONTAINER_REGISTRY_NAME="linuscontainerregistry"
AZURE_DEFAULTS_LOCATION="germanywestcentral"
AZURE_DEFAULTS_GROUP="storage-resource-group"
CLUSTER="linusaks"
ARM_CLIENT_ID="bfd2093e-583a-454e-ab49-36a9f4922f10"
ARM_CLIENT_SECRET="4dS8Q~4pVr_Bl4g0JI05FuZSM8z2DqbMGNkDmdaC"
ARM_TENANT_ID="b9a54e03-5aaf-479f-ad8c-71b81cf06164"

# create resource group
echo "${Green}Creating resource group...${NC}"
az group create -n $AZURE_DEFAULTS_GROUP -l $AZURE_DEFAULTS_LOCATION

# create container registry
echo "${Green}Creating container registry...${NC}"
az acr create -n $CONTAINER_REGISTRY_NAME --sku Basic

# Login to service principal
echo "${Green}Logging in to service principal...${NC}"
az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID

# attach to aks cluster
echo "${Green}Attaching container registry to aks cluster...${NC}"
az aks update -n $CLUSTER -g $CLUSTER_GROUP_NAME --attach-acr $CONTAINER_REGISTRY_NAME

# login to container registry
echo "${Green}Logging in to container registry...${NC}"
az acr login --name $CONTAINER_REGISTRY_NAME

# Taging image
echo "${Green}Tagging image...${NC}"
docker tag btc:1.0.0 "${CONTAINER_REGISTRY_NAME}.azurecr.io/btc:1.0.0"

# push image to container registry
echo "${Green}Pushing image to container registry...${NC}"
docker push linuscontainerregistry.azurecr.io/btc:1.0.0