#!/bin/sh

DEFAULTS_LOCATION="germanywestcentral"
AZURE_DEFAULTS_GROUP="linus-rg"
CLUSTER="linusaks"
IP_ADDRESS_NAME="linus-loadbalancer-ip"
CLIENT_ID="bfd2093e-583a-454e-ab49-36a9f4922f10"
SUBSCRIPTION_ID="2a70cd88-34b2-4240-9c18-221c1564239d"

export NODE_RESOURCE_GROUP=$(az aks show --name $CLUSTER --query nodeResourceGroup -o tsv)


# az network public-ip create \
#     --resource-group $NODE_RESOURCE_GROUP \
#     --name $IP_ADDRESS_NAME \
#     --sku Standard \
#     --allocation-method static

export LOAD_BALANCER_IP=$(az network public-ip show --resource-group $NODE_RESOURCE_GROUP --name $IP_ADDRESS_NAME --query ipAddress --output tsv)
echo "LOAD_BALANCER_IP: $LOAD_BALANCER_IP"

az role assignment create \
    --assignee $CLIENT_ID \
    --role "Network Contributor" \
    --scope /subscriptions/$SUBSCRIPTION_ID/resourceGroups/$NODE_RESOURCE_GROUP

envsubst < service.yaml | kubectl apply -f -
kubectl apply -f deployment.yaml