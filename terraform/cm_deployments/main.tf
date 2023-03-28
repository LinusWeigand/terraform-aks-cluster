resource "random_uuid" "test" {}

data "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = var.cluster_name
  resource_group_name = var.resource_group_name
}

locals {
  load_balancer_dns_label_name = "lb-${random_uuid.test.result}"
  kubelet_client_id            = data.azurerm_kubernetes_cluster.aks_cluster.kubelet_identity[0].client_id
}



# resource "kubernetes_manifest" "clusterissuer-selfsigned" {
#   manifest = yamldecode(templatefile(
#     "${path.module}/clusterissuer-selfsigned.yaml", {}
#   ))
# }

resource "kubernetes_manifest" "www-certificate" {
  manifest = yamldecode(templatefile(
    "${path.module}/certificate.yaml", {
      "name"            = "www-tls"
      "namespace"       = var.namespace
      "common_name"     = "www.${var.domain}"
      "dns_name"        = "www.${var.domain}"
      "issuer_ref_name" = "letsencrypt-staging"
    }
  ))
}

resource "kubernetes_manifest" "root-certificate" {
  manifest = yamldecode(templatefile(
    "${path.module}/certificate.yaml", {
      "name"            = "root-tls"
      "namespace"       = var.namespace
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
# data "kubernetes_service" "helloweb" {
#   metadata {
#     name      = "helloweb"
#     namespace = "default"
#   }
# }

# data "kubernetes_service" "ingress-nginx-controller" {
#   metadata {
#     name      = "ingress-nginx-controller"
#     namespace = "ingress-basic"
#   }
# }

resource "azurerm_dns_a_record" "root" {
  name                = "@"
  zone_name           = var.domain
  resource_group_name = var.resource_group_name

  ttl = 3600

  # records = [data.kubernetes_service.helloweb.status[0].load_balancer[0].ingress[0].ip]
  records = [azurerm_public_ip.loadbalancer_public_ip.ip_address]
  # records = [data.kubernetes_service.ingress-nginx-controller.status[0].load_balancer[0].ingress[0].ip]
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
      "kubelet_client_id"   = local.kubelet_client_id
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
      "kubelet_client_id"   = local.kubelet_client_id
    }
  ))
}

# resource "kubernetes_service" "helloweb" {
#   metadata {
#     name = "helloweb"
#     annotations = {
#       "service.beta.kubernetes.io/azure-dns-label-name"               = local.load_balancer_dns_label_name
#       "service.beta.kubernetes.io/azure-load-balancer-resource-group" = var.node_resource_group
#     }
#   }

#   spec {
#     selector = {
#       app  = "hello"
#       tier = "web"
#     }

#     type             = "LoadBalancer"
#     load_balancer_ip = azurerm_public_ip.loadbalancer_public_ip.ip_address

#     port {
#       port        = 443
#       target_port = 8443
#       protocol    = "TCP"
#     }
#   }
# }

resource "azurerm_public_ip" "loadbalancer_public_ip" {
  name                = "${var.name}-loadbalancer-ip"
  location            = var.location
  resource_group_name = var.node_resource_group
  allocation_method   = "Static"
  sku                 = "Standard"
}

# data "azurerm_resource_group" "node_resource_group" {
#   name = var.node_resource_group
# }

# resource "azurerm_role_assignment" "network_contributor" {
#   scope                = data.azurerm_resource_group.node_resource_group.id
#   role_definition_name = "Network Contributor"
#   principal_id         = data.azurerm_kubernetes_cluster.aks_cluster.kubelet_identity[0].object_id
# }



