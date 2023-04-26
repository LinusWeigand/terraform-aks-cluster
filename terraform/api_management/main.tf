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
resource "azurerm_api_management_backend_pool" "backend_pool" {
  name                = "backend-pool"
  resource_group_name = var.resource_group_name
  api_management_name = azurerm_api_management.apim.name
  backend {
    url      = "https://my-backend-url.com"
    protocol = "https"
  }
}


resource "azurerm_api_management_authorization_server" "keycloak_authorization_server" {
  name                         = "keycloak-authorization-server"
  resource_group_name          = var.resource_group_name
  api_management_name          = azurerm_api_management.apim.name
  display_name                 = "Keycloak Authorization Server"
  authorization_methods        = ["GET", "POST"]
  client_authentication_method = ["Basic"]
  grant_types = [
    "authorization_code",
    "implicit",
    "client_credentials",
    "password",
    "refresh_token"
  ]
  token_lifetime_in_seconds    = 3600 # 1 hour
  client_registration_endpoint = "https://keycloak.example.com/auth/realms/my-realm/clients"
  authorization_endpoint       = "https://keycloak.example.com/auth/realms/my-realm/protocol/openid-connect/auth"  # Get authorization code and id token
  token_endpoint               = "https://keycloak.example.com/auth/realms/my-realm/protocol/openid-connect/token" # Get access, refresh token
  end_session_endpoint         = "https://keycloak.example.com/auth/realms/my-realm/protocol/openid-connect/logout"
  bearer_token_sending_methods = ["authorizationHeader"]
  default_scope                = "openid"
}
