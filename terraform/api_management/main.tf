resource "azurerm_api_management" "apim" {
  name = "${var.name}-apim"
  location = var.location
  resource_group_name = var.resource_group_name
  publisher_name = var.name
  publisher_email = var.email

  sku_name = "Developer_1"
}
