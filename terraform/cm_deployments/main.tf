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

resource "random_uuid" "test" {}

data "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = var.cluster_name
  resource_group_name = var.resource_group_name
}

locals {
  load_balancer_dns_label_name     = "lb-${random_uuid.test.result}"
  user_assigned_identity_client_id = data.azurerm_kubernetes_cluster.aks_cluster.kubelet_identity[0].client_id
}



# resource "kubernetes_manifest" "clusterissuer-selfsigned" {
#   manifest = yamldecode(templatefile(
#     "${path.module}/clusterissuer-selfsigned.yaml", {}
#   ))
# }

resource "kubernetes_manifest" "www-certificate" {
  manifest = yamldecode(templatefile(
    "${path.module}/certificate.yaml", {
      "name"            = "www"
      "namespace"       = "default"
      "common_name"     = "www.${var.domain}"
      "dns_name"        = "www.${var.domain}"
      "issuer_ref_name" = "letsencrypt-staging"
    }
  ))
}

resource "kubernetes_manifest" "root-certificate" {
  manifest = yamldecode(templatefile(
    "${path.module}/certificate.yaml", {
      "name"            = "root"
      "namespace"       = "default"
      "common_name"     = var.domain
      "dns_name"        = var.domain
      "issuer_ref_name" = "letsencrypt-staging"
    }
  ))
}


resource "azurerm_dns_cname_record" "www" {
  name                = "www"
  zone_name           = var.domain
  resource_group_name = var.resource_group_name

  ttl = 3600

  record = "${local.load_balancer_dns_label_name}.${var.location}.cloudapp.azure.com"
}

# data of service helloweb

data "kubernetes_service" "helloweb" {
  metadata {
    name      = "helloweb"
    namespace = "default"
  }
}

resource "azurerm_dns_a_record" "root" {
  name                = "@"
  zone_name           = var.domain
  resource_group_name = var.resource_group_name

  ttl = 3600

  records = [data.kubernetes_service.helloweb.status[0].load_balancer[0].ingress[0].ip]
}

# data for azurerm_role_assignment cert_manager_identity_dns_zone_contributor
# data "azurerm_role_definition" "cert_manager_identity_dns_zone_contributor" {
#   name = "DNS Zone Contributor"
# }

resource "kubernetes_manifest" "clusterissuer-lets-encrypt-staging" {
  manifest = yamldecode(templatefile(
    "${path.module}/clusterissuer-lets-encrypt-staging.yaml", {
      "email"               = var.email
      "resource_group_name" = var.resource_group_name
      "subscription_id"     = var.subscription_id
      "domain"              = var.domain
      "identity_client_id"  = local.user_assigned_identity_client_id
    }
  ))
}
resource "kubernetes_manifest" "clusterissuer-lets-encrypt-production" {
  manifest = yamldecode(templatefile(
    "${path.module}/clusterissuer-lets-encrypt-production.yaml", {
      "email"               = var.email
      "resource_group_name" = var.resource_group_name
      "subscription_id"     = var.subscription_id
      "domain"              = var.domain
      "identity_client_id"  = local.user_assigned_identity_client_id
    }
  ))
}

# resource "kubernetes_manifest" "deployment" {
#   manifest = yamldecode(templatefile(
#     "${path.module}/deployment.yaml", {}
#   ))
# }

# resource "kubernetes_manifest" "service" {
#   manifest = yamldecode(templatefile(
#     "${path.module}/service.yaml", {
#       "dns_label_name" = local.load_balancer_dns_label_name
#     }
#   ))
# }




