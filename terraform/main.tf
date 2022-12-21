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


# Resource Group
resource "azurerm_resource_group" "resource_group" {
  name     = "${var.name}-rg"
  location = var.location
}

# Virtual Network
module "vnet" {
  source                    = "./vnet"
  name                      = "linus"
  location                  = "germanywestcentral"
  network_address_space     = "192.168.0.0/16"
  aks_subnet_address_name   = "aks"
  aks_subnet_address_prefix = "192.168.0.0/24"
  subnet_address_name       = "appgw"
  subnet_address_prefix     = "192.168.1.0/24"
}

# Log Analytics
module "log_analytics" {
  source   = "./log_analytics"
  name     = "linus"
  location = "germanywestcentral"
}

# Kubernetes Cluster
module "aks" {

  source                     = "./aks"
  name                       = "linus"
  location                   = "germanywestcentral"
  kubernetes_version         = "1.24.6"
  agent_count                = 3
  vm_size                    = "Standard_DS2_v2"
  ssh_public_key             = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDeKC5qE4+lWfW+QNh2ZuUKKoWh6jXiv2Rm0HyjdPuHiEb67TovTwYL/pfYomU0XDy9zmMsbLVRRm370ITNT0wOby2oZVN/ezaSBf9X2Mlrs4iykuf8715lfJi9xfy+aJFgNsdN28f+YvGPGU2O8KavSKtARoaXgE4wx1TWUHJIjxUw0XDdDdyJXvzQxAXqmOesPjaqq6vJymmM01NgvPBheIg0m93T849CQ8wS4JouhAdznJ+AR+YX/RgK54F9OvgI6HFQg1e4puh2P+tcmTsYiqLGu+Fj8pvK7kjQoLBe4PJFNzf2zh5qrCTkrfu2pg9KoGY2uykDmae2iDgkaAGJYbE2UVk6vcfGXiy9W4UMZXAyQa8vhmInUHAJBnSgcILmUClArgx73e+fJ5dINrW1KaKX+uMpNa751N804ksF9rvK/qZinFOCIW06+zrA0NNrl7Ws5TyZs0mvQYb22mSw0tOOye7uzUBFNwJD79oo2ft9QgbfkgXObW1J6sp+Edk= linus@LAPTOP-FU4LQFR3"
  aks_admins_group_object_id = "d0819c2d-cf12-40b7-b2cf-169cff1e2927"
}

# Kubernetes Deployments
module "aks_deployments" {
  source   = "./aks_deployments"
  name     = "linus"
  location = "germanywestcentral"
}
