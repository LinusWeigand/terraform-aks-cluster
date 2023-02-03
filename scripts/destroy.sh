#!/bin/sh

# Navigate into terraform directory
cd ..
cd terraform

terraform destroy -auto-approve

# Delete resource group storage-resource-group
az group delete --name storage-resource-group --yes

# Delete resource group NetworkWatcherRG
az group delete --name NetworkWatcherRG --yes
