resource "azurerm_kubernetes_cluster" "myaks" {
  name                    = var.cluster_name
  location                = var.location
  resource_group_name     = var.resource_group
  dns_prefix              = var.dns_prefix
  private_cluster_enabled = true


  default_node_pool {
    name           = "system"
    node_count     = var.node_count
    vm_size        = "Standard_B2s"
    vnet_subnet_id = azurerm_subnet.subnet.id
  }

  identity {
    type = "SystemAssigned"
  }

  linux_profile {
    admin_username = "ubuntu"

    ssh_key {
      key_data = file(var.ssh_public_key)
    }
  }
  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "standard"
  }
  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }
}
