resource "kubernetes_deployment" "reverse_proxy_deployment" {
  metadata {
    name      = "reverse_proxy_deployment"
    namespace = "default"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "reverse_proxy"
      }
    }

    template {
      metadata {
        labels = {
          app = "reverse_proxy"
        }
      }

      spec {
        container {
          image = "nginx:latest"
          name  = "reverse_proxy"

          port {
            container_port = 8080
          }
        }
      }
    }
  }
}
