resource "azurerm_virtual_network" "virtual_network" {
  name                = "${var.name}-vnet"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [var.network_address_space]
}

resource "azurerm_subnet" "aks_subnet" {
  name                 = var.aks_subnet_address_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = [var.aks_subnet_address_prefix]
}

# resource "azurerm_subnet" "appgw_subnet" {
#   name                 = var.subnet_address_name
#   resource_group_name  = var.resource_group_name
#   virtual_network_name = azurerm_virtual_network.virtual_network.name
#   address_prefixes     = [var.subnet_address_prefix]
# }

# Static ip address

# resource "azurerm_public_ip" "appgw_public_ip" {
#   name                = "${var.name}-appgw-ip"
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   allocation_method   = "Static"
#   sku                 = "Standard"
# }

# DNS Zone
# resource "azurerm_dns_zone" "dns_zone" {
#   name                = var.domain
#   resource_group_name = var.resource_group_name
# }

