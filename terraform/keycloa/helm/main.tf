resource "helm_release" "keycloak" {
  name       = "keycloak"
  repository = "https://codecentric.github.io/helm-charts"
  chart      = "keycloak"
  namespace  = var.namespace

  set {
    name  = "keycloak.username"
    value = "admin"
  }

  set {
    name  = "keycloak.password"
    value = var.keycloak_admin_password
  }

  set {
    name  = "keycloak.extraEnv.KEYCLOAK_HOSTNAME"
    value = "linusweigand.de/keycloak"
  }

  set {
    name  = "keycloak.extraEnv.PROXY_ADDRESS_FORWARDING"
    value = "true"
  }
}
