resource "kubernetes_deployment" "keycloak" {
  metadata {
    name      = "keycloak"
    namespace = "default"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "keycloak"
      }
    }

    template {
      metadata {
        labels = {
          app = "keycloak"
        }
      }

      spec {
        container {
          image = "jboss/keycloak:latest"
          name  = "keycloak"

          port {
            container_port = 8180
          }
        }
      }
    }
  }
}
