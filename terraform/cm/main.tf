resource "azurerm_dns_zone" "dns_zone" {
  name                = var.domain
  resource_group_name = var.resource_group_name

}

resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = "cert-manager"
  }
}

resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  version          = "v1.7.1"
  create_namespace = false
  namespace        = kubernetes_namespace.cert_manager.metadata.0.name

  set {
    name  = "installCRDs"
    value = "true"
  }

  set {
    name  = "logLevel"
    value = "debug"
  }

  depends_on = [kubernetes_namespace.cert_manager]
}

# -------------------------------------- Secret API Token --------------------------------------
resource "kubernetes_secret" "letsencrypt_cloudflare_api_token_secret" {
  metadata {
    name      = "letsencrypt-cloudflare-api-token-secret"
    namespace = kubernetes_namespace.cert_manager.metadata[0].name
  }
  type = "Opaque"
  data = {
    api_token = var.cloudflare_api_token
    email     = var.cloudflare_email
  }

  depends_on = [helm_release.cert_manager, kubernetes_namespace.cert_manager]
}

# -------------------------------------- CLuster Issuer --------------------------------------
# resource "kubernetes_manifest" "letsencrypt_issuer_staging" {
#   manifest = yamldecode(templatefile(
#     "${path.module}/letsencrypt-issuer.tpl.yaml",
#     {
#       "name"                      = "letsencrypt-staging"
#       "email"                     = var.cloudflare_email
#       "server"                    = "https://acme-staging-v02.api.letsencrypt.org/directory"
#       "api_token_secret_name"     = kubernetes_secret.letsencrypt_cloudflare_api_token_secret.metadata.0.name
#       "api_token_secret_data_key" = keys(kubernetes_secret.letsencrypt_cloudflare_api_token_secret.data).0
#     }
#   ))

#   depends_on = [helm_release.cert_manager, kubernetes_namespace.cert_manager, kubernetes_secret.letsencrypt_cloudflare_api_token_secret]
# }

# resource "kubernetes_manifest" "letsencrypt_issuer_production" {
#   manifest = yamldecode(templatefile(
#     "${path.module}/letsencrypt-issuer.tpl.yaml",
#     {
#       "name"                      = "letsencrypt-production"
#       "email"                     = var.cloudflare_email
#       "server"                    = "https://acme-v02.api.letsencrypt.org/directory"
#       "api_token_secret_name"     = kubernetes_secret.letsencrypt_cloudflare_api_token_secret.metadata.0.name
#       "api_token_secret_data_key" = keys(kubernetes_secret.letsencrypt_cloudflare_api_token_secret.data).0
#     }
#   ))

#   depends_on = [helm_release.cert_manager, kubernetes_namespace.cert_manager, kubernetes_secret.letsencrypt_cloudflare_api_token_secret]
# }

# -------------------------------------- Certificate --------------------------------------
# resource "kubernetes_manifest" "certificate" {
#   manifest = yamldecode(templatefile(
#     "${path.module}/certificate.tpl.yaml",
#     {
#       "name"      = "aks-linusweigand-com"
#       "namespace" = kubernetes_namespace.cert_manager.metadata[0].name
#       "domain"    = var.domain
#       "issuer"    = "letsencrypt-staging"
#     }
#   ))

#   depends_on = [kubernetes_manifest.letsencrypt_issuer_staging, kubernetes_namespace.cert_manager]
# }

