resource "azurerm_application_gateway" "gateway" {
  name                = "gateway"
  location            = var.location
  resource_group_name = var.resource_group

  sku {
    name     = "WAF_Medium"
    tier     = "WAF"
    capacity = 2
  }

  waf_configuration {
    enabled          = "true"
    firewall_mode    = "Detection"
    rule_set_type    = "OWASP"
    rule_set_version = "3.2"
  }

  gateway_ip_configuration {
    name      = "gateway_ip_configuration"
    subnet_id = azurerm_subnet.subnet.id
  }

  frontend_ip_configuration {
    name                 = "gateway_frontend_ip_configuration"
    public_ip_address_id = azurerm_public_ip.public_ip.id
  }

  frontend_port {
    name = "https-frontend-port"
    port = 443
  }

  backend_address_pool {
    name = "gateway_backend_address_pool"
  }

  backend_http_settings {
    name                  = "gateway_backend_http_settings"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 30
  }

  http_listener {
    name                           = "gateway-http-listener"
    frontend_ip_configuration_name = one(azurerm_application_gateway.gateway.frontend_ip_configuration[*].name)
    frontend_port_name             = one(azurerm_application_gateway.gateway.frontend_port[*].name)
    protocol                       = "Https"
  }

  request_routing_rule {
    name                       = "gateway-request-routing-rule"
    rule_type                  = "Basic"
    http_listener_name         = one(azurerm_application_gateway.gateway.http_listener[*].name)
    backend_address_pool_name  = one(azurerm_application_gateway.gateway.backend_address_pool[*].name)
    backend_http_settings_name = one(azurerm_application_gateway.gateway.backend_http_settings[*].name)
  }

  tags = {
    environment = var.environment
  }
}
