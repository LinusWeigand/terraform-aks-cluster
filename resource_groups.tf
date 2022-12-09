resource "azurerm_resource_group" "aks-resources" {
  name     = "sandbox"
  location = var.location
}
