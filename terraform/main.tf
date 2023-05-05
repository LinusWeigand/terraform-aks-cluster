terraform {
  required_providers {
    azurerm = {
      source  = "azurerm"
      version = "=3.36.0"
    }

    kubernetes = {
      source  = "kubernetes"
      version = "=2.16.1"
    }

    helm = {
      source  = "helm"
      version = "=2.8.0"
    }

    random = {
      source  = "random"
      version = "3.4.3"
    }
  }
  backend "azurerm" {
    resource_group_name  = "storage-resource-group"
    storage_account_name = "storageaccountlinus"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
  client_id     = var.CLIENT_ID
  client_secret = var.CLIENT_SECRET
  tenant_id     = var.TENANT_ID
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}


provider "kubernetes" {
  config_path = "~/.kube/config"
}
# Resource Group
# resource "azurerm_resource_group" "resource_group" {
#   name     = "${var.name}-rg"
#   location = var.location
# }

locals {
  cluster_name        = "${var.name}aks"
  node_resource_group = "${var.name}-node-rg"
}

# Virtual Network
module "vnet" {
  source                    = "./vnet"
  name                      = var.name
  location                  = var.location
  network_address_space     = "192.168.0.0/16"
  aks_subnet_address_name   = "aks"
  aks_subnet_address_prefix = "192.168.0.0/24"
  subnet_address_name       = "appgw"
  subnet_address_prefix     = "192.168.1.0/24"
  resource_group_name       = var.resource_group_name
  domain                    = var.domain
}

# Log Analytics
# module "log_analytics" {
#   source              = "./log_analytics"
#   name                = "linus"
#   location            = "germanywestcentral"
#   resource_group_name = var.resource_group_name
# }

# Container Registry
module "container-registry" {
  source              = "./container_registry"
  location            = var.location
  resource_group_name = var.resource_group_name
  client_id           = var.CLIENT_ID
}

# Kubernetes Cluster
module "aks" {
  source                     = "./aks"
  name                       = local.cluster_name
  location                   = var.location
  kubernetes_version         = "1.25.5"
  agent_count                = 1
  vm_size                    = "Standard_B2s"
  ssh_public_key             = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDeKC5qE4+lWfW+QNh2ZuUKKoWh6jXiv2Rm0HyjdPuHiEb67TovTwYL/pfYomU0XDy9zmMsbLVRRm370ITNT0wOby2oZVN/ezaSBf9X2Mlrs4iykuf8715lfJi9xfy+aJFgNsdN28f+YvGPGU2O8KavSKtARoaXgE4wx1TWUHJIjxUw0XDdDdyJXvzQxAXqmOesPjaqq6vJymmM01NgvPBheIg0m93T849CQ8wS4JouhAdznJ+AR+YX/RgK54F9OvgI6HFQg1e4puh2P+tcmTsYiqLGu+Fj8pvK7kjQoLBe4PJFNzf2zh5qrCTkrfu2pg9KoGY2uykDmae2iDgkaAGJYbE2UVk6vcfGXiy9W4UMZXAyQa8vhmInUHAJBnSgcILmUClArgx73e+fJ5dINrW1KaKX+uMpNa751N804ksF9rvK/qZinFOCIW06+zrA0NNrl7Ws5TyZs0mvQYb22mSw0tOOye7uzUBFNwJD79oo2ft9QgbfkgXObW1J6sp+Edk= linus@LAPTOP-FU4LQFR3"
  aks_admins_group_object_id = "d0819c2d-cf12-40b7-b2cf-169cff1e2927"
  resource_group_name        = var.resource_group_name
  subnet_id                  = module.vnet.subnet_id
  dns_zone_id                = var.dns_zone_id
  node_resource_group        = local.node_resource_group
  container_registry_id      = module.container-registry.container_registry_id

}

# module "cert-manager" {
#
#   resource_group_name  = var.resource_group_name
#   cert_manager_version = "v1.11.0"
#   domain               = var.domain
#   cluster_name         = local.cluster_name
#   location             = var.location
#
#   depends_on = [
#     module.aks,
#   ]
# }
# #
# module "cert-manager-deployments" {
#   source              = "./cm_deployments"
#   resource_group_name = var.resource_group_name
#   domain              = var.domain
#   email               = var.email
#   subscription_id     = var.SUBSCRIPTION_ID
#   location            = var.location
#   cluster_name        = local.cluster_name
#   node_resource_group = local.node_resource_group
#   name                = var.name
#   namespace           = "ingress-basic"
#
#   depends_on = [
#     module.cert-manager
#   ]
# }
#
# module "api-management" {
#   source              = "./api_management"
#   resource_group_name = var.resource_group_name
#   location            = var.location
#   name                = var.name
#   email               = var.email
#   domain              = var.domain
#   subnet_id           = module.vnet.subnet_id
#   client_id           = var.CLIENT_ID
#   client_secret       = var.CLIENT_SECRET
# }
#
# module "keycloak" {
#   source                  = "./keycloa/helm"
#   keycloak_admin_password = var.KEYCLOAK_ADMIN_PASSWORD
#   namespace               = "ingress-basic"
# }

# module "ingress-controller" {
#   source              = "./ing_controller"
#   resource_group_name = var.resource_group_name
#   cluster_name        = local.cluster_name

#   depends_on = [
#     module.cert-manager
#   ]
# }




