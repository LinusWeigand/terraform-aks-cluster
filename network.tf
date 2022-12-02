# Virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet"
  address_space       = ["10.0.0.0/16"]
  location            = vars.location
  resource_group_name = vars.resource_group
}

# Subnet
resource "azurerm_subnet" "subnet" {
  name                 = "subnet"
  resource_group_name  = vars.resource_group
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Public IP
resource "azurerm_public_ip" "publicip" {
  name                = "publicip"
  location            = vars.location
  resource_group_name = vars.resource_group
  allocation_method   = "Dynamic"
}
