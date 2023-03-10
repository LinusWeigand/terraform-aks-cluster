#!/bin/sh

RESOURCE_GROUP_NAME="linus-rg"
CLUSTER="linusaks"

USER_ASSIGNED_IDENTITY_NAME="cert-manager-identity"
DOMAIN_NAME="linusweigand.de"
DNS_ZONE_RESOURCE_GROUP="dns-zones"
SERVICE_ACCOUNT_NAME="cert-manager"
SERVICE_ACCOUNT_NAMESPACE="cert-manager" 

# sh create-storage-account.sh 

# Navigate into terraform directory
cd ..
cd terraform

# Run tf init
terraform init -migrate-state -upgrade

# Run tf apply
terraform apply -auto-approve

az aks get-credentials --resource-group $RESOURCE_GROUP_NAME --name $CLUSTER --admin --overwrite-existing

# echo "Updating cluster..."
# az aks update \
#     --resource-group ${RESOURCE_GROUP_NAME} \
#     --name ${CLUSTER} \
#     --enable-oidc-issuer \
#     --enable-workload-identity

# echo "Creating user assigned identity..."
# az identity create -g $RESOURCE_GROUP_NAME --name $USER_ASSIGNED_IDENTITY_NAME

# echo "Creating role assignment..."
# az role assignment create \
#     --role "DNS Zone Contributor" \
#     --assignee "$(az identity show -g $RESOURCE_GROUP_NAME --name $USER_ASSIGNED_IDENTITY_NAME --query 'clientId' -o tsv)" \
#     --scope "$(az network dns zone show -g $DNS_ZONE_RESOURCE_GROUP --name $DOMAIN_NAME -o tsv --query id)"


# echo "Creating identity federated-credential..."
# az identity federated-credential create \
#   --resource-group $RESOURCE_GROUP_NAME \
#   --name "cert-manager" \
#   --identity-name "${USER_ASSIGNED_IDENTITY_NAME}" \
#   --issuer "$(az aks show --resource-group $RESOURCE_GROUP_NAME --name $CLUSTER --query "oidcIssuerProfile.issuerUrl" -o tsv)"  \
#   --subject "system:serviceaccount:$SERVICE_ACCOUNT_NAMESPACE:$SERVICE_ACCOUNT_NAME"

# echo "Identity client id:"
# az identity show -g $RESOURCE_GROUP_NAME --name $USER_ASSIGNED_IDENTITY_NAME --query 'clientId' -o tsv