resource "azurerm_resource_group" "container_resource_group" {
  name     = "container-resource-group"
  location = var.location
}

resource "azurerm_container_registry" "linuscontainerregistry" {
  name                = "linuscontainerregistry"
  resource_group_name = azurerm_resource_group.container_resource_group.name
  location            = var.location
  sku                 = "Basic"
}

resource "azurerm_role_assignment" "Owner" {
  scope                = azurerm_container_registry.linuscontainerregistry.id
  role_definition_name = "Owner"
  principal_id         = var.client_id
}

# Error: authorization.RoleAssignmentsClient#Create: Failure responding to request: StatusCode=400 -- Original Error: autorest/azure: Service returned an error. Status=400 Code="PrincipalNo
# tFound" Message="Principal dc8ab886034f412fb8be71b20d2da7e0 does not exist in the directory b9a54e03-5aaf-479f-ad8c-71b81cf06164. Check that you have the correct principal ID. If you are cr
#   role_definition_name = "Owner"
# h as ServicePrincipal, User, or Group.  See https://aka.ms/docs-principaltype"
#
