resource "azurerm_resource_group" "aks-resources" {
  name     = var.resource_group
  location = var.location
}
