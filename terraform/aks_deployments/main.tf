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
    key                  = "vnet-terraform.tfstate"
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


resource "kubernetes_deployment" "azure-vote-back" {
  metadata {
    name = "azure-vote-back"
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "azure-vote-back"
      }
    }
    template {
      metadata {
        labels = {
          app = "azure-vote-back"
        }
      }
      spec {
        node_selector = {
          "kubernetes.io/os" = "linux"
        }
        container {
          name  = "azure-vote-back"
          image = "mcr.microsoft.com/oss/bitnami/redis:6.0.8"
          env {
            name  = "ALLOW_EMPTY_PASSWORD"
            value = "yes"
          }
          resources {
            requests {
              cpu    = "100m"
              memory = "128Mi"
            }
            limits {
              cpu    = "250m"
              memory = "256Mi"
            }
          }
          port {
            container_port = 6379
            name           = "redis"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "azure-vote-back" {
  metadata {
    name = "azure-vote-back"
  }
  spec {
    selector = {
      app = "azure-vote-back"
    }
    port {
      port        = 6379
      target_port = 6379
    }
  }
}

resource "kubernetes_deployment" "azure-vote-front" {
  metadata {
    name = "azure-vote-front"
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "azure-vote-front"
      }
    }
    template {
      metadata {
        labels = {
          app = "azure-vote-front"
        }
      }
      spec {
        node_selector = {
          "kubernetes.io/os" = "linux"
        }
        container {
          name  = "azure-vote-front"
          image = "mcr.microsoft.com/azuredocs/azure-vote-front:v1"
          resources {
            requests {
              cpu    = "100m"
              memory = "128Mi"
            }
            limits {
              cpu    = "250m"
              memory = "256Mi"
            }
          }
          port {
            container_port = 80
          }
          env {
            name  = "REDIS"
            value = "azure-vote-back"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "azure-vote-front" {
  metadata {
    name = "azure-vote-front"
  }
  spec {
    type = "LoadBalancer"
    selector = {
      app = "azure-vote-front"
    }
    port {
      port        = 80
      target_port = 80
    }
  }
}

resource "kubernetes_ingress" "ingress" {
  metadata {
    name = "ingress"
    annotations = {
      "kubernetes.io/ingress.class" = "azure/application-gateway"
    }
  }
  spec {
    rule {
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service_name = kubernetes_service.azure-vote-front.metadata.0.name
            service_port = kubernetes_service.azure-vote-front.spec.0.port.0.target_port
          }
        }
      }
    }
  }
}