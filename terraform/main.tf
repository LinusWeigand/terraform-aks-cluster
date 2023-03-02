terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.36.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "=2.16.1"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "=3.9.1"
    }

    helm = {
      source  = "helm"
      version = "=2.8.0"
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
  client_id       = var.CLIENT_ID
  client_secret   = var.CLIENT_SECRET
  tenant_id       = var.TENANT_ID
  subscription_id = var.SUBSCRIPTION_ID
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "cloudflare" {
  email     = var.cloudflare_email
  api_token = var.cloudflare_api_token
}


provider "kubernetes" {
  config_path = "~/.kube/config"
}

# Resource Group
resource "azurerm_resource_group" "resource_group" {
  name     = "${var.name}-rg"
  location = var.location
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
  resource_group_name       = azurerm_resource_group.resource_group.name
}

# Log Analytics
# module "log_analytics" {
#   source              = "./log_analytics"
#   name                = "linus"
#   location            = "germanywestcentral"
#   resource_group_name = azurerm_resource_group.resource_group.name
# }

# Kubernetes Cluster
module "aks" {
  source                     = "./aks"
  name                       = var.name
  location                   = var.location
  kubernetes_version         = "1.24.6"
  agent_count                = 3
  vm_size                    = "Standard_DS2_v2"
  ssh_public_key             = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDeKC5qE4+lWfW+QNh2ZuUKKoWh6jXiv2Rm0HyjdPuHiEb67TovTwYL/pfYomU0XDy9zmMsbLVRRm370ITNT0wOby2oZVN/ezaSBf9X2Mlrs4iykuf8715lfJi9xfy+aJFgNsdN28f+YvGPGU2O8KavSKtARoaXgE4wx1TWUHJIjxUw0XDdDdyJXvzQxAXqmOesPjaqq6vJymmM01NgvPBheIg0m93T849CQ8wS4JouhAdznJ+AR+YX/RgK54F9OvgI6HFQg1e4puh2P+tcmTsYiqLGu+Fj8pvK7kjQoLBe4PJFNzf2zh5qrCTkrfu2pg9KoGY2uykDmae2iDgkaAGJYbE2UVk6vcfGXiy9W4UMZXAyQa8vhmInUHAJBnSgcILmUClArgx73e+fJ5dINrW1KaKX+uMpNa751N804ksF9rvK/qZinFOCIW06+zrA0NNrl7Ws5TyZs0mvQYb22mSw0tOOye7uzUBFNwJD79oo2ft9QgbfkgXObW1J6sp+Edk= linus@LAPTOP-FU4LQFR3"
  aks_admins_group_object_id = "d0819c2d-cf12-40b7-b2cf-169cff1e2927"
  resource_group_name        = azurerm_resource_group.resource_group.name
  akssubnet_id               = module.vnet.akssubnet_id
}

# module "aks_deployments" {
#   source               = "./aks_deployments"
#   name                 = "linus"
#   location             = "germanywestcentral"
#   cloudflare_email     = var.cloudflare_email
#   cloudflare_api_token = var.cloudflare_api_token
# }

module "cert-manager" {
  source               = "./cm"
  cloudflare_email     = var.cloudflare_email
  cloudflare_api_token = var.cloudflare_api_token
  resource_group_name  = azurerm_resource_group.resource_group.name
}

module "cert-manager-deployments" {
  source               = "./cm_deployments"
  cloudflare_email     = var.cloudflare_email
  cloudflare_api_token = var.cloudflare_api_token
  resource_group_name  = azurerm_resource_group.resource_group.name
}

# module "traefik" {
#   source               = "./tr"
#   cloudflare_email     = var.cloudflare_email
#   cloudflare_api_token = var.cloudflare_api_token
# }

# resource "kubernetes_namespace" "traefik" {
#   metadata {
#     name = "traefik"
#   }

#   depends_on = [
#     module.aks,
#   ]
# }

# Configure Traefik to use the the certificate stored in the kubernetes secret aks-linusweigand-com-tls
# resource "helm_release" "traefik" {
#   name       = "traefik"
#   repository = "https://helm.traefik.io/traefik"
#   chart      = "traefik"
#   version    = "10.14.2"
#   namespace  = kubernetes_namespace.traefik.metadata.0.name

#   values = [
#     "${file("${path.module}/traefik-values.yaml")}",
#   ]

#   set {
#     name  = "routes.default.rule"
#     value = "Host(`aks.linusweigand.com`) && PathPrefix(`/`)"
#   }

#   set {
#     name  = "routes.default.tls.secretName"
#     value = "aks-linusweigand-com-tls"
#   }
# }


# data "kubernetes_service" "azure-vote-front" {
#   metadata {
#     name = "azure-vote-front"
#   }
# }

# resource "cloudflare_record" "azure-vote-front" {
#   zone_id = var.zone_id
#   name    = "aks"
#   type    = "A"
#   proxied = false

#   data {
#     service  = "azure-vote-front"
#     proto    = "TCP"
#     name     = "azure-vote-front"
#     priority = 10
#     weight   = 100
#     port     = 443
#     target   = "linusweigand.com"
#   }

# }
