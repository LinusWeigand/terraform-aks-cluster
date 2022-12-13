# Virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet"
  address_space       = ["10.1.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group
}

# Subnet
resource "azurerm_subnet" "subnet" {
  name                 = "subnet"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = var.resource_group
  address_prefixes     = ["10.1.0.0/24"]
}

# Public IP
resource "azurerm_public_ip" "public_ip" {
  name                = "publicip"
  location            = var.location
  resource_group_name = var.resource_group
  allocation_method   = "Dynamic"
}
