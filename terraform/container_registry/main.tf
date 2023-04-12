resource "azurerm_resource_group" "container_resource_group" {
  name     = "container-resource-group"
  location = var.location
}

resource "azurerm_container_registry" "linuscontainerregistry" {
  name                = "linuscontainerregistry"
  resource_group_name = azurerm_resource_group.container_resource_group.name
  location            = var.location
  sku                 = "Basic"
}

resource "azurerm_role_assignment" "acr_push" {
  scope                = azurerm_container_registry.linuscontainerregistry.id
  role_definition_name = "AcrPush"
  principal_id         = var.client_id
}
