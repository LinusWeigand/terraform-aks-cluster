# -------------------------------------- Secret API Token --------------------------------------
resource "kubernetes_secret" "letsencrypt_cloudflare_api_token_secret" {
  metadata {
    name      = "letsencrypt-cloudflare-api-token-secret"
    namespace = "cert-manager"
  }
  type = "Opaque"
  data = {
    api_token = var.cloudflare_api_token
    email     = var.cloudflare_email
  }

}

# -------------------------------------- CLuster Issuer --------------------------------------
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

}

# -------------------------------------- Certificate --------------------------------------
resource "kubernetes_manifest" "certificate" {
  manifest = yamldecode(templatefile(
    "${path.module}/certificate.tpl.yaml",
    {
      "name"      = "linusweigand"
      "namespace" = "cert-manager"
      "domain"    = var.domain
      "issuer"    = "letsencrypt-staging"
    }
  ))

}

