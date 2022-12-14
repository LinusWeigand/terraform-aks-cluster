resource "kubernetes_deployment" "nodejs_app_deployment" {
  metadata {
    name      = "nodejs_app_deployment"
    namespace = "default"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "nodejs_app"
      }
    }

    template {
      metadata {
        labels = {
          app = "nodejs_app"
        }
      }

      spec {
        container {
          image = "node:latest"
          name  = "nodejs_app"

          port {
            container_port = 8080
          }
        }
      }
    }
  }
}
