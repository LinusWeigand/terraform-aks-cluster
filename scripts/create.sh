#!/bin/sh
Green='\033[0;32m'
NC='\033[0m'

AZURE_DEFAULTS_LOCATION="germanywestcentral"
AZURE_DEFAULTS_GROUP="linus-rg"
# DOMAIN_NAME="linusweigand.de"
CLUSTER="linusaks"

# USER_ASSIGNED_IDENTITY_NAME="cert-manager-identity"
# SERVICE_ACCOUNT_NAME="cert-manager"
# SERVICE_ACCOUNT_NAMESPACE="cert-manager" 

# EMAIL_ADDRESS="linus@couchtec.com"
# AZURE_SUBSCRIPTION="2a70cd88-34b2-4240-9c18-221c1564239d"
# AZURE_SUBSCRIPTION_ID="2a70cd88-34b2-4240-9c18-221c1564239d"

# sh create-storage-account.sh 

# Navigate into terraform directory
cd ..
cd terraform

# Run tf init
terraform init -migrate-state -upgrade -lock=false

# Run tf apply
terraform apply -auto-approve -lock=false

az aks get-credentials --name $CLUSTER --admin --overwrite-existing

# cd ..
# cd scripts/cert-manager

# -------------------------------- Workload Identity --------------------------------------------

# echo "${Green}Creating user assigned identity...${NC}"
# az identity create --name $USER_ASSIGNED_IDENTITY_NAME
# USER_ASSIGNED_IDENTITY_CLIENT_ID=$(az identity show --name "${USER_ASSIGNED_IDENTITY_NAME}" --query 'clientId' -o tsv)

# sleep 5

# echo "${Green}Creating role assignment...${NC}"
# az role assignment create \
#     --role "DNS Zone Contributor" \
#     --assignee "$(az identity show --name $USER_ASSIGNED_IDENTITY_NAME --query 'clientId' -o tsv)" \
#     --scope "$(az network dns zone show --name $DOMAIN_NAME -o tsv --query id)"

# echo "${Green}Creating identity federated-credential...${NC}"
# az identity federated-credential create \
#   --name "cert-manager" \
#   --identity-name "${USER_ASSIGNED_IDENTITY_NAME}" \
#   --issuer "$(az aks show --resource-group $AZURE_DEFAULTS_GROUP --name $CLUSTER --query "oidcIssuerProfile.issuerUrl" -o tsv)"  \
#   --subject "system:serviceaccount:$SERVICE_ACCOUNT_NAMESPACE:$SERVICE_ACCOUNT_NAME"

# ------------------------------------ 

# USER_ASSIGNED_IDENTITY_CLIENT_ID=$(az aks show -n $CLUSTER --query "identityProfile.kubeletidentity.clientId" -o tsv)

# echo "${Green}Deploying Cluster Issuer Lets Encrypt Staging...${NC}"
# envsubst < clusterissuer-lets-encrypt-staging.yaml | kubectl apply -f  -

# echo "${Green}Deploying certificate...${NC}"
# envsubst < certificate.yaml | kubectl apply -f -
# kubectl patch certificate www --type merge  -p '{"spec":{"issuerRef":{"name":"letsencrypt-staging"}}}'

# echo "${Green}Deploy Sample Web Server...${NC}"
# kubectl apply -f deployment.yaml
# AZURE_LOADBALANCER_DNS_LABEL_NAME=lb-$(uuidgen) 
# envsubst < service.yaml | kubectl apply -f -

# echo "${Green}Creating DNS CNAME Record...${NC}"
# az network dns record-set cname set-record \
#     --zone-name $DOMAIN_NAME \
#     --cname $AZURE_LOADBALANCER_DNS_LABEL_NAME.$AZURE_DEFAULTS_LOCATION.cloudapp.azure.com \
#     --record-set-name www