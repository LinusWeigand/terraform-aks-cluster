resource "azurerm_kubernetes_cluster" "cluster" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "${var.name}dns"
  kubernetes_version  = var.kubernetes_version

  node_resource_group = var.node_resource_group

  linux_profile {
    admin_username = "ubuntu"

    ssh_key {
      key_data = var.ssh_public_key
    }
  }

  default_node_pool {
    name                 = "agentpool"
    node_count           = var.agent_count
    vm_size              = var.vm_size
    vnet_subnet_id       = var.subnet_id
    type                 = "VirtualMachineScaleSets"
    orchestrator_version = var.kubernetes_version
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    load_balancer_sku = "standard"
    network_plugin    = "azure"
  }

  role_based_access_control_enabled = "true"

  azure_active_directory_role_based_access_control {
    managed                = true
    admin_group_object_ids = [var.aks_admins_group_object_id]
  }

}

data "azurerm_resource_group" "node_resource_group" {
  name = azurerm_kubernetes_cluster.cluster.node_resource_group
  depends_on = [
    azurerm_kubernetes_cluster.cluster
  ]
}

resource "azurerm_role_assignment" "node_infrastructure_update_scale_set" {
  principal_id         = azurerm_kubernetes_cluster.cluster.kubelet_identity[0].object_id
  scope                = data.azurerm_resource_group.node_resource_group.id
  role_definition_name = "Virtual Machine Contributor"
  depends_on = [
    azurerm_kubernetes_cluster.cluster
  ]
}

resource "azurerm_role_assignment" "dns_contributor" {
  scope                            = var.dns_zone_id
  role_definition_name             = "DNS Zone Contributor"
  principal_id                     = azurerm_kubernetes_cluster.cluster.kubelet_identity[0].object_id
  skip_service_principal_aad_check = true # Allows skipping propagation of identity to ensure assignment succeeds.
}

resource "azurerm_role_assignment" "network_contributor" {
  scope                = data.azurerm_resource_group.node_resource_group.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_kubernetes_cluster.cluster.kubelet_identity[0].object_id
  depends_on = [
    azurerm_kubernetes_cluster.cluster
  ]
}

resource "azurerm_role_assignment" "acr_pull" {
  principal_id                     = azurerm_kubernetes_cluster.cluster.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  skip_service_principal_aad_check = true
  scope                            = var.container_registry_id
}
