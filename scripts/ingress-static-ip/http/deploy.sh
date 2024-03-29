#!/bin/sh

export DEFAULTS_LOCATION="germanywestcentral"
export AZURE_DEFAULTS_GROUP="linus-rg"
export CLUSTER="linusaks"
export IP_ADDRESS_NAME="linus-loadbalancer-ip"
export NAMESPACE="ingress-basic"
export NODE_RESOURCE_GROUP=$(az aks show --name $CLUSTER --query nodeResourceGroup -o tsv)
export DOMAIN_NAME="linusweigand.de"
export LOAD_BALANCER_IP=$(az network public-ip show --resource-group $NODE_RESOURCE_GROUP --name $IP_ADDRESS_NAME --query ipAddress --output tsv)

# helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
# helm repo update

helm install ingress-nginx ingress-nginx/ingress-nginx \
  --create-namespace \
  --namespace $NAMESPACE \
  --set controller.replicaCount=1 \
  --set controller.nodeSelector."kubernetes\.io/os"=linux \
  --set defaultBackend.nodeSelector."kubernetes\.io/os"=linux \
  --set controller.service.externalTrafficPolicy=Local \
  --set controller.service.loadBalancerIP=$LOAD_BALANCER_IP 

# az network dns record-set a add-record \
#     --zone-name $DOMAIN_NAME \
#     --record-set-name "@" \
#     --ipv4-address $LOAD_BALANCER_IP


kubectl apply -f aks-helloworld-one.yaml --namespace $NAMESPACE
kubectl apply -f aks-helloworld-two.yaml --namespace $NAMESPACE
kubectl apply -f hello-world-ingress.yaml --namespace $NAMESPACE