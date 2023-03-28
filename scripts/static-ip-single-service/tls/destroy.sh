
#!/bin/sh

DEFAULTS_LOCATION="germanywestcentral"
AZURE_DEFAULTS_GROUP="linus-rg"
CLUSTER="linusaks"
NODE_RESOURCE_GROUP=$(az aks show --name $CLUSTER --query nodeResourceGroup -o tsv)
IP_ADDRESS_NAME="linus-loadbalancer-ip"

CLIENT_ID="bfd2093e-583a-454e-ab49-36a9f4922f10"
SUBSCRIPTION_ID="2a70cd88-34b2-4240-9c18-221c1564239d"

kubectl delete -f deployment.yaml
kubectl delete -f service.yaml	

# az network public-ip delete \
#     --resource-group $NODE_RESOURCE_GROUP \
#     --name $IP_ADDRESS_NAME

az role assignment delete \
    --assignee $CLIENT_ID \
    --role "Network Contributor" \
    --scope /subscriptions/$SUBSCRIPTION_ID/resourceGroups/$NODE_RESOURCE_GROUP

