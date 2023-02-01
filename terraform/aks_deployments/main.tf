# resource "kubernetes_deployment" "azure-vote-back" {
#   metadata {
#     name = "azure-vote-back"
#   }
#   spec {
#     replicas = 3
#     selector {
#       match_labels = {
#         app = "azure-vote-back"
#       }
#     }
#     template {
#       metadata {
#         labels = {
#           app = "azure-vote-back"
#         }
#       }
#       spec {
#         node_selector = {
#           "kubernetes.io/os" = "linux"
#         }
#         container {
#           name  = "azure-vote-back"
#           image = "mcr.microsoft.com/oss/bitnami/redis:6.0.8"
#           env {
#             name  = "ALLOW_EMPTY_PASSWORD"
#             value = "yes"
#           }
#           resources {
#             requests = {
#               cpu    = "100m"
#               memory = "128Mi"
#             }
#             limits = {
#               cpu    = "250m"
#               memory = "256Mi"
#             }
#           }
#           port {
#             container_port = 6379
#             name           = "redis"
#           }
#         }
#       }
#     }
#   }
# }

# resource "kubernetes_service" "azure-vote-back" {
#   metadata {
#     name = "azure-vote-back"
#   }
#   spec {
#     selector = {
#       app = "azure-vote-back"
#     }
#     port {
#       port        = 6379
#       target_port = 6379
#     }
#   }
# }

# resource "kubernetes_deployment" "azure-vote-front" {
#   metadata {
#     name = "azure-vote-front"
#   }
#   spec {
#     replicas = 3
#     selector {
#       match_labels = {
#         app = "azure-vote-front"
#       }
#     }
#     template {
#       metadata {
#         labels = {
#           app = "azure-vote-front"
#         }
#       }
#       spec {
#         node_selector = {
#           "kubernetes.io/os" = "linux"
#         }
#         container {
#           name  = "azure-vote-front"
#           image = "mcr.microsoft.com/azuredocs/azure-vote-front:v1"
#           resources {
#             requests = {
#               cpu    = "100m"
#               memory = "128Mi"
#             }
#             limits = {
#               cpu    = "250m"
#               memory = "256Mi"
#             }
#           }
#           port {
#             container_port = 80
#           }
#           env {
#             name  = "REDIS"
#             value = "azure-vote-back"
#           }
#         }
#       }
#     }
#   }
# }

# resource "kubernetes_service" "azure-vote-front" {
#   metadata {
#     name = "azure-vote-front"
#   }
#   spec {
#     type = "LoadBalancer"
#     selector = {
#       app = "azure-vote-front"
#     }
#     port {
#       port        = 80
#       target_port = 80
#     }
#   }
# }

# resource "kubernetes_ingress_v1" "ingress" {
#   metadata {
#     name = "ingress"
#     annotations = {
#       "kubernetes.io/ingress.class" = "azure/application-gateway"
#     }
#   }
#   spec {
#     rule {
#       http {
#         path {
#           path = "/"
#           backend {
#             service {
#               name = kubernetes_service.azure-vote-front.metadata.0.name
#               port {
#                 number = kubernetes_service.azure-vote-front.spec.0.port.0.target_port
#               }
#             }
#           }
#         }
#       }
#     }
#   }
# }

resource "kubernetes_ingress_v1" "ingress" {
  metadata {
    name      = "ingress"
    namespace = "default"
    annotations = {
      "cert-manager.io/cluster-issuer"           = "letsencrypt-production"
      "traefik.ingress.kubernetes.io/router.tls" = "true"
    }
  }

  spec {
    rule {
      host = "aks.linusweigand.com"

      http {
        path {
          path = "/"

          backend {
            service {
              name = "azure-vote-front"

              port {
                number = 80
              }
            }
          }
        }
      }
    }

    tls {
      hosts       = ["linusweigand.com"]
      secret_name = "azure-vote-front-tls-secret"
    }
  }
}

# Azure vote front tls secret
resource "kubernetes_secret" "azure-vote-front-secret" {
  metadata {
    name      = "azure-vote-front-tls-secret"
    namespace = "default"
  }

  data = {
    api_token = var.cloudflare_api_token
    email     = var.cloudflare_email
  }
}
