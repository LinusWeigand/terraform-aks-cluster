data "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster_name
  resource_group_name = var.resource_group_name
}

resource "helm_release" "ingress-nginx" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.5.2"

  namespace        = "ingress-basic"
  create_namespace = true

  set {
    name  = "controller.service.loadBalancerIP"
    value = data.azurerm_kubernetes_cluster.aks.kube_config.0.host
  }
}