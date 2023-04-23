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
resource "azurerm_api_management_openid_connect_provider" "keycloak_oidc_provider" {
  name                = "keycloak-oidc-provider"
  resource_group_name = var.resource_group_name
  api_management_name = azurerm_api_management.apim.name
  metadata_endpoint   = "https://keycloak.example.com/auth/realms/my-realm/.well-known/openid-configuration"
  client_id           = var.client_id
  client_secret       = var.client_secret
  redirect_uri        = ["https://www.linusweigand.de/callback"]
  scope               = ["openid", "profile", "email"]
  }

}
