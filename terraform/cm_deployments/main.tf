# # -------------------------------------- Secret API Token --------------------------------------
# resource "kubernetes_secret" "letsencrypt_cloudflare_api_token_secret" {
#   metadata {
#     name      = "letsencrypt-cloudflare-api-token-secret"
#     namespace = "cert-manager"
#   }
#   type = "Opaque"
#   data = {
#     api_token = var.cloudflare_api_token
#     email     = var.cloudflare_email
#   }

# }

# # -------------------------------------- CLuster Issuer --------------------------------------
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

# }

# # -------------------------------------- Certificate --------------------------------------
# resource "kubernetes_manifest" "certificate" {
#   manifest = yamldecode(templatefile(
#     "${path.module}/certificate.tpl.yaml",
#     {
#       "name"      = "linusweigand"
#       "namespace" = "default"
#       "domain"    = var.domain
#       "issuer"    = "letsencrypt-staging"
#     }
#   ))
# }

# # -------------------------------------- Test --------------------------------------

# resource "kubernetes_manifest" "clusterissuer-selfsigned" {
#   manifest = yamldecode(templatefile(
#     "${path.module}/clusterissuer-selfsigned.yaml", {}
#   ))
# }

resource "kubernetes_manifest" "certificate" {
  manifest = yamldecode(templatefile(
    "${path.module}/certificate.yaml", {
      "domain"    = var.domain
      "namespace" = "default"
    }
  ))
}

# resource "azurerm_dns_cname_record" "example" {
#   name                = "www"
#   zone_name           = "linusweigand.de"
#   resource_group_name = "dns-zones"

#   ttl = 3600

#   record = "lb-c5c1cd1c-6104-43e8-a42a-ba6504f6d731.germanywestcentral.cloudapp.azure.com"
# }

resource "kubernetes_manifest" "clusterissuer-lets-encrypt-staging" {
  manifest = yamldecode(templatefile(
    "${path.module}/clusterissuer-lets-encrypt-staging.yaml", {
      "email"                        = var.email
      "dns_zone_resource_group_name" = "dns-zones"
      "subscription_id"              = var.subscription_id
      "domain"                       = var.domain
      "identity_id"                  = "8bd1a9c5-5dfb-4ee8-aeb9-983cc0868f77"
      "identity_resource_group_name" = "identities"
    }
  ))
}



