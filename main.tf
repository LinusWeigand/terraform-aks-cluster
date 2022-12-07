# Azure Provider source and version being used 
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.34.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "=2.16.1"
    }
    keycloak = {
      source  = "mrparkers/keycloak"
      version = "=4.1.0"
    }
  }
}
# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  # docs: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs
  # client_id in ARM_CLIENT_ID 
  # client_secret in ARM_CLIENT_SECRET 
  # tenant_id in ARM_TENANT_ID 
  # subscription_id in ARM_SUBSCRIPTION_ID
}

provider "kubernetes" {
  # docs: https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs
  # host in KUBE_HOST
  # client_certificate in KUBE_CLIENT_CERT_DATA
  # client_key in KUBE_CLIENT_KEY_DATA
  # cluster_ca_certificate in KUBE_CLUSTER_CA_CERT_DATA
}

provider "keycloak" {
  # docs: https://registry.terraform.io/providers/mrparkers/keycloak/latest/docs
  # client_id in KEYCLOAK_CLIENT_ID
  # url in KEYCLOAK_URL
  # client_secret in KEYCLOAK_CLIENT_SECRET
}
