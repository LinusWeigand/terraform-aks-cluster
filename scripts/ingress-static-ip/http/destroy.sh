#!/bin/sh

export DEFAULTS_LOCATION="germanywestcentral"
export AZURE_DEFAULTS_GROUP="linus-rg"
export CLUSTER="linusaks"
export IP_ADDRESS_NAME="linus-loadbalancer-ip"
export NAMESPACE="ingress-basic"
export NODE_RESOURCE_GROUP=$(az aks show --name $CLUSTER --query nodeResourceGroup -o tsv)
export DOMAIN_NAME="linusweigand.de"
export LOAD_BALANCER_IP=$(az network public-ip show --resource-group $NODE_RESOURCE_GROUP --name $IP_ADDRESS_NAME --query ipAddress --output tsv)

helm delete ingress-nginx -n $NAMESPACE

# az network dns record-set a remove-record \
#     --zone-name $DOMAIN_NAME \
#     --record-set-name "@" \
#     --ipv4-address $LOAD_BALANCER_IP

kubectl delete -f aks-helloworld-one.yaml --namespace $NAMESPACE
kubectl delete -f aks-helloworld-two.yaml --namespace $NAMESPACE
kubectl delete -f hello-world-ingress.yaml --namespace $NAMESPACE

kubectl delete namespace $NAMESPACE