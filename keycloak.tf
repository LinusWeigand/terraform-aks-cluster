resource "kubernetes_deployment" "keycloak" {

  metadata {
    name = "keycloak"
    labels = {
      app = "keycloak"
    }
  }

  spec {
    replicas = 3

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
          image = "jboss/keycloak:11.0.3"
          name  = "keycloak"
          
          env {
            name  = "KEYCLOAK_USER"
            value = "admin"
          }
          env {
            name  = "KEYCLOAK_PASSWORD"
            value = "admin"
          }
          env {
            name  = "PROXY_ADDRESS_FORWARDING"
            value = "true"
          }
          env {
            name  = "DB_VENDOR"
            value = "h2"
          }
          env {
            name  = "DB_ADDR"
            value = "localhost"
          }
          env {
            name  = "DB_DATABASE"
            value = "keycloak"
          }
          env {
            name  = "DB_USER"
            value = "keycloak"
          }
          env {
            name  = "DB_PASSWORD"
            value = "keycloak"
          }
          env {
            name  = "DB_PORT"
            value = "5432"
          }
          env {
            name  = "DB_SCHEMA"
            value = "public"
          }
          env {
            name  = "DB_VENDOR"
            value = "postgres"
          }
          env {
            name  = "DB_ADDR"
            value = "keycloak-postgres"
          }
          env {
            name  = "DB_DATABASE"
            value = "keycloak"
          }
          env {
            name  = "DB_USER"
            value = "keycloak"
          }
          env {
            name  = "DB_PASSWORD"
            value = "keycloak"
          }
          env {
            name  = "DB_PORT"
            value = "5432"
          }
          env {
            name  = "DB_SCHEMA"
            value = "public"
          }
          env {
            name  = "DB_VENDOR"
            value = "postgres"
          }
          env {
            name  = "DB_ADDR"
            value = "keycloak-postgres"
          }
          env {
            name  = "DB_DATABASE"
            value = "keycloak"
          }
          env {
            name  = "DB_USER"
            value = "keycloak"
          }
          env {
            name  = "DB_PASSWORD"
            value = "keycloak"
          }
        }
      }
    }
  }
}
