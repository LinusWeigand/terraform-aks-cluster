resource "azurerm_dns_zone" "example" {
  name                = var.domain
  resource_group_name = "linus-rg"
}

resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = "cert-manager"
  }
}

resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "v1.7.1"
  namespace  = kubernetes_namespace.cert_manager.metadata.0.name

  set {
    name  = "installCRDs"
    value = "true"
  }
}
resource "kubernetes_secret" "letsencrypt_cloudflare_api_token_secret" {
  metadata {
    name      = "letsencrypt-cloudflare-api-token-secret"
    namespace = kubernetes_namespace.cert_manager.metadata[0].name
  }
  data = {
    api_token = var.cloudflare_api_token
    email     = var.cloudflare_email
  }
}

resource "kubernetes_manifest" "letsencrypt_issuer_staging" {
  manifest = yamldecode(templatefile(
    "${path.module}/letsencrypt-issuer.tpl.yaml",
    {
      "name"                      = "letsencrypt-staging"
      "email"                     = var.cloudflare_email
      "server"                    = "https://acme-staging-v02.api.letsencrypt.org/directory"
      "api_token_secret_name"     = kubernetes_secret.letsencrypt_cloudflare_api_token_secret.metadata.0.name
      "api_token_secret_data_key" = keys(kubernetes_secret.letsencrypt_cloudflare_api_token_secret.data).0
    }
  ))

  depends_on = [helm_release.cert_manager]
}

resource "kubernetes_manifest" "letsencrypt_issuer_production" {
  manifest = yamldecode(templatefile(
    "${path.module}/letsencrypt-issuer.tpl.yaml",
    {
      "name"                      = "letsencrypt-production"
      "email"                     = var.cloudflare_email
      "server"                    = "https://acme-v02.api.letsencrypt.org/directory"
      "api_token_secret_name"     = kubernetes_secret.letsencrypt_cloudflare_api_token_secret.metadata.0.name
      "api_token_secret_data_key" = keys(kubernetes_secret.letsencrypt_cloudflare_api_token_secret.data).0
    }
  ))

  depends_on = [helm_release.cert_manager]
}
