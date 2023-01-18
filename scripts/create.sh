#!/bin/sh

RESOURCE_GROUP_NAME="linus-rg"
AKS_CLUSTER_NAME="linusaks"
DOMAIN_NAME="linusweigand.com"

# Navigate into terraform directory
cd ..
cd terraform

# Run tf init
terraform init -migrate-state

# Run tf apply
terraform apply -auto-approve

# Navigate back to scripts directory
cd ..
cd scripts

az aks get-credentials --resource-group $RESOURCE_GROUP_NAME --name $AKS_CLUSTER_NAME --admin --overwrite-existing

az network dns zone create --name $DOMAIN_NAME --resource-group linus-rg