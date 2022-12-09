# Provider source and version being used 
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
    azuread = {
      source  = "hashicorp/azuread"
      version = "=2.31.0"
    }
  }
}
# Configure the Providers

provider "azurerm" {
  # docs: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs
  # client_id in ARM_CLIENT_ID 
  # client_secret in ARM_CLIENT_SECRET 
  # tenant_id in ARM_TENANT_ID 
  # subscription_id in ARM_SUBSCRIPTION_ID
  client_id       = var.CLIENT_ID
  client_secret   = var.CLIENT_SECRET
  tenant_id       = var.TENANT_ID
  subscription_id = var.SUBSCRIPTION_ID
  features {}
}

provider "kubernetes" {
  # docs: https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs
  # KUBERNETES_SERVICE_HOST and KUBERNETES_SERVICE_PORT will be set automatically
}

provider "keycloak" {
  # docs: https://registry.terraform.io/providers/mrparkers/keycloak/latest/docs
  # client_id in KEYCLOAK_CLIENT_ID
  # url in KEYCLOAK_URL
  # client_secret in KEYCLOAK_CLIENT_SECRET
}
