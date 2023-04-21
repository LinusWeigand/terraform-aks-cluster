resource "azurerm_api_management" "apim" {
  name                = "${var.name}-apim"
  location            = var.location
  resource_group_name = var.resource_group_name
  publisher_name      = var.name
  publisher_email     = var.email

  sku_name = "Developer_1"

  hostname_configuration {
    type     = "Proxy"
    hostname = var.domain
    certificate {
      # TODO  
    }
  }
}

resource "azurerm_api_management_api" "apimapi" {
  name                = "apimapi"
  resource_group_name = var.resource_group_name
  api_management_name = azurerm_api_management.apim.name
  display_name        = "Api Management Api"
  path                = "test"
  protocols           = ["https"]

  authentication_settings {
    openid {

    }
  }

}
