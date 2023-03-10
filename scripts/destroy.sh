#!/bin/sh

RESOURCE_GROUP_NAME="linus-rg"
USER_ASSIGNED_IDENTITY_NAME="cert-manager-identity" 

# Navigate into terraform directory
cd ..
cd terraform

az identity delete --name $USER_ASSIGNED_IDENTITY_NAME --resource-group $RESOURCE_GROUP_NAME

terraform destroy -auto-approve

# Delete resource group storage-resource-group
az group delete --name storage-resource-group --yes

# Delete resource group NetworkWatcherRG
az group delete --name NetworkWatcherRG --yes
