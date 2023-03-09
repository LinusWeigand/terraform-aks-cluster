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

resource "azurerm_user_assigned_identity" "cert_manager_identity" {
  name                = "cert-manager-identity"
  resource_group_name = var.resource_group_name
}

resource "azuread_application" "cert_manager_app" {
  name = "cert-manager"
}

resource "azuread_application_federated_identity" "cert_manager_federated_identity" {
  application_object_id = azuread_application.cert_manager_app.object_id
}

resource "azuread_application_federated_identity_credential" "cert_manager_federated_credential" {
  federated_identity_object_id = azuread_application_federated_identity.cert_manager_federated_identity.object_id
  issuer                       = "https://germanywestcentral.oic.prod-aks.azure.com/b9a54e03-5aaf-479f-ad8c-71b81cf06164/b3686d14-60c4-440f-8890-4c49a438fa2b/"
  subject                      = "system:serviceaccount:cert-manager:cert-manager"
}

data "azurerm_dns_zone" "linusweigand_de" {
  name                = var.domain
  resource_group_name = var.resource_group_name
}

resource "azurerm_role_assignment" "cert_manager_identity_dns_zone_contributor" {
  scope                = data.azurerm_dns_zone.linusweigand_de.id
  role_definition_name = "DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.cert_manager_identity.principal_id
}


