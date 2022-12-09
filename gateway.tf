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
    rule_set_version = "3.0"
  }

  gateway_ip_configuration {
    name      = "gateway-ip-configuration"
    subnet_id = azurerm_subnet.subnet.id
  }

  frontend_port {
    name = "http"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "vnet-feip"
    public_ip_address_id = azurerm_public_ip.public_ip.id
  }

  backend_address_pool {
    name = "vnet-beap"
  }

  backend_http_settings {
    name                  = "vnet-http-settings"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 1
  }
  backend_address_pool_id = azurerm_kubernetes_cluster.myaks.id

  http_listener {
    name                           = "vnet-httplstn"
    frontend_ip_configuration_name = "vnet-feip"
    frontend_port_name             = "vnet-feport"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "vnet-rqrt"
    rule_type                  = "Basic"
    http_listener_name         = "vnet-httplstn"
    backend_address_pool_name  = "vnet-beap"
    backend_http_settings_name = "vnet-be-htst"
  }

  tags = {
    environment = var.environment
  }
}
