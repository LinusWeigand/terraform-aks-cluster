resource "kubernetes_namespace" "traefik" {
  metadata {
    name = "traefik"
  }
}

resource "kubernetes_deployment" "traefik" {
  metadata {
    name      = "traefik"
    namespace = kubernetes_namespace.traefik.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "traefik"
      }
    }

    template {
      metadata {
        labels = {
          app = "traefik"
        }
      }

      spec {
        container {
          name  = "traefik"
          image = "traefik:v2.5.3"

          ports {
            container_port = 80
            name           = "http"
          }

          ports {
            container_port = 443
            name           = "https"
          }

          args = [
            "--api.insecure",
            "--log.level=DEBUG",
            "--providers.kubernetesingress",
            "--entrypoints.web.address=:80",
            "--entrypoints.websecure.address=:443",
            "--certificatesresolvers.myresolver.acme.email=linus@couchtec.com",
            "--certificatesresolvers.myresolver.acme.storage=acme.json",
            "--certificatesresolvers.myresolver.acme.tlschallenge",
          ]
        }
      }
    }
  }
}

resource "kubernetes_service" "traefik" {
  metadata {
    name      = "traefik"
    namespace = kubernetes_namespace.traefik.metadata[0].name
  }

  spec {
    selector = {
      app = "traefik"
    }

    port {
      name        = "http"
      port        = 80
      target_port = 80
    }

    port {
      name        = "https"
      port        = 443
      target_port = 443
    }
  }
}

resource "kubernetes_ingress" "name" {
  metadata {
    name      = "nodejs-app"
    namespace = kubernetes_namespace.traefik.metadata[0].name
  }

  spec {
    rule {
      host = "btc.linusweigand.com"

      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            name = "nodejs-app"
            port {
              name = "http"
              port = 80
            }
          }
        }
      }
    }

    tls {
      secret_name = "nodekjs-app-tls"
      hosts = [
        "btc.linusweigand.com"
      ]
    }
  }
}

resource "kubenetes_secret" "tls-cert" {
  metadata {
    name      = "nodekjs-app-tls"
    namespace = kubernetes_namespace.traefik.metadata[0].name
  }

  data = {
    tls.crt = filebase64("certs/btc.linusweigand.com.crt")
    tls.key = filebase64("certs/btc.linusweigand.com.key")
  }
}

resource "kubernetes_ingress" "traefik-dashboard" {
  metadata {
    name      = "traefik-dashboard"
    namespace = kubernetes_namespace.traefik.metadata[0].name
  }

  spec {
    rule {
      host = "traefik-dashboard.linusweigand.com"

      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            name = "traefik"
            port {
              name = "web"
              port = 8080
            }
          }
        }
      }
    }

    tls {
      secret_name = "dashboard-tls"
      hosts = [
        "traefik-dashboard.linusweigand.com"
      ]
    }
  }
}

resource "kubernetes_secret" "dashboard-tls" {
  metadata {
    name      = "dashboard-tls"
    namespace = kubernetes_namespace.traefik.metadata[0].name
  }

  data = {
    tls.crt = filebase64("certs/traefik-dashboard.linusweigand.com.crt")
    tls.key = filebase64("certs/traefik-dashboard.linusweigand.com.key")
  }
}

resource "kubernetes_config_map" "traefik-config" {
  metadata {
    name = "traefik-config"
  }

  data = {
    acme.json    = "{}"
    traefik.toml = <<EOF
[api]
  entryPoint = "traefik"
  dashboard = true
[log]
  level = "DEBUG"
[providers]
  [providers.kubernetes]
    namespace = "traefik"
    ingressClass = "traefik"
[entryPoints]
  [entryPoints.web]
    address = ":80"
  [entryPoints.web-secure]
    address = ":443"
    [entryPoints.web-secure.tls]
  [certificatesResolvers.myresolver]
    acme = {
      email = "youremail@example.com"
      storage = "acme.json"
      [acme.httpChallenge]
        entryPoint = "traefik"
    }
EOF
  }
}

resource "kubernetes_ingress" "cert-manager" {
  metadata {
    name      = "cert-manager"
    namespace = kubernetes_namespace.traefik.metadata[0].name
  }

  spec {
    tls {
      secret_name = "cert-manager-tls"
      hosts = [
        "cert-manager.linusweigand.com"
      ]
    }
  }
}

resource "kubernetes_secret" "cert-manager-tls" {
  metadata {
    name      = "cert-manager-tls"
    namespace = kubernetes_namespace.traefik.metadata[0].name
  }

  data = {
    tls.crt = filebase64("certs/cert-manager.linusweigand.com.crt")
    tls.key = filebase64("certs/cert-manager.linusweigand.com.key")
  }
}
