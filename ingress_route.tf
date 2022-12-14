resource "kubernetes_ingress" "ingress_route" {
  metadata {
    name      = "ingress_route"
    namespace = "default"
  }

  spec {

    backend {
      service_name = "reverse_proxy_service"
      service_port = 8080
    }

    rule {
      http {
        path {
          path {
            backend {
              service_name = "reverse_proxy_service"
              service_port = 8080
            }

            path = "/"
          }
        }
      }
    }
  }
}
