#!/bin/sh

RESOURCE_GROUP_NAME="storage-resource-group"
STORAGE_ACCOUNT_NAME="storageaccountlinus"

# Create Resource Group
az group create -l germanywestcentral -n $RESOURCE_GROUP_NAME

# Create Storage Account
az storage account create -n $STORAGE_ACCOUNT_NAME -g $RESOURCE_GROUP_NAME -l germanywestcentral --sku Standard_LRS

# Create Storage Account blob
az storage container create  --name tfstate --account-name $STORAGE_ACCOUNT_NAME