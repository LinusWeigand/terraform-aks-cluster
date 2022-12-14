resource "kubernetes_service" "reverse_proxy_service" {
  metadata {
    name      = "reverse_proxy_service"
    namespace = "default"
  }

  spec {
    selector = {
      app = "reverse_proxy"
    }

    port {
      port        = 8080
      target_port = 8080
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_service" "keycloak_service" {
  metadata {
    name      = "keycloak_service"
    namespace = "default"
  }

  spec {
    selector = {
      app = "keycloak"
    }

    port {
      port        = 8180
      target_port = 8180
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_service" "nodejs_app_service" {
  metadata {
    name      = "nodejs_app_service"
    namespace = "default"
  }

  spec {
    selector = {
      app = "nodejs_app"
    }

    port {
      port        = 3000
      target_port = 3000
    }

    type = "ClusterIP"
  }
}
