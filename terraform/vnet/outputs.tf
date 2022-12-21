output "akssubnet_id" {
  value = data.azurerm_subnet.akssubnet.id
}

output "appgwsubnet_id" {
  value = data.azurerm_subnet.appgwsubnet.id
}


