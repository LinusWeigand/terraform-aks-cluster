terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.36.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "storage-resource-group"
    storage_account_name = "storageaccountlinus"
    container_name       = "tfstate"
    key                  = "KTaXGKE6RvT7MX2XuKo3dWiSVGDst/9AHu2kVKmSA6V/jgY2/HN1+pP1hw9KKA/w/T67nkGLWA+k+AStJRMSNw=="
    subscription_id      = "2a70cd88-34b2-4240-9c18-221c1564239d"
  }
}

provider "azurerm" {
  features {}
  client_id       = var.CLIENT_ID
  client_secret   = var.CLIENT_SECRET
  tenant_id       = var.TENANT_ID
  subscription_id = var.SUBSCRIPTION_ID
}

module "vnet" {
  source = "./vnet"
}

module "log_analytics" {
  source = "./log_analytics"
}

module "aks" {
  source = "./aks"
}

module "aks_deployments" {
  source = "./aks_deployments"
}
