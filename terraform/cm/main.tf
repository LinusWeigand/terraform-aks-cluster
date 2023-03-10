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


  values = [
    "${file("${path.module}/cert-manager-values.yaml")}",
  ]
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

# data "azurerm_dns_zone" "linusweigand_de" {
#   name                = var.domain
# }

# data "azurerm_kubernetes_cluster" "aks" {
#   name                = var.cluster_name
#   resource_group_name = var.resource_group_name
# }

# resource "azurerm_user_assigned_identity" "cert_manager_identity" {
#   name                = "cert-manager-identity"
#   resource_group_name = var.resource_group_name
#   location            = var.location
# }

# resource "azurerm_role_assignment" "cert_manager_identity_dns_zone_contributor" {
#   scope                = data.azurerm_dns_zone.linusweigand_de.id
#   role_definition_name = "DNS Zone Contributor"
#   principal_id         = azurerm_user_assigned_identity.cert_manager_identity.principal_id
# }

# resource "azuread_application" "cert_manager_app" {
#   display_name = "cert-manager"
# }

# resource "azuread_application_federated_identity_credential" "cert_manager_federated_credential" {
#   display_name          = "cert-manager"
#   application_object_id = azuread_application.cert_manager_app.object_id
#   issuer                = data.azurerm_kubernetes_cluster.aks.oidc_issuer_url
#   subject               = "system:serviceaccount:cert-manager:cert-manager"
#   audiences = [
#     "api://AzureADTokenExchange"
#   ]
# }






