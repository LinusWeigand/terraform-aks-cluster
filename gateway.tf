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
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.public_ip.id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 443
  }

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  backend_http_settings {
    name                  = local.backend_http_settings_name
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 30
  }

  http_listener {
    name                           = local.http_listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Https"
    # ssl_certificate_name           = local.ssl_certificate_name
  }

  # ssl_certificate {
  #   name     = local.ssl_certificate_name
  #   data     = filebase64("certs/cert.pem")
  #   password = filebase64("certs/key.pem")
  # }

  request_routing_rule {
    name                       = "gateway-request-routing-rule"
    rule_type                  = "Basic"
    http_listener_name         = local.http_listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.backend_http_settings_name
  }

  tags = {
    environment = var.environment
  }
}

locals {
  frontend_ip_configuration_name = "gateway_frontend_ip_configuration"
  frontend_port_name             = "https-frontend-port"
  http_listener_name             = "gateway_http_listener"
  backend_address_pool_name      = "gateway_backend_address_pool"
  backend_http_settings_name     = "gateway_backend_http_settings"
  ssl_certificate_name           = "gateway_ssl_certificate"
}
