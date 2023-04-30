# terraform {
#   required_providers {
#     keycloak = {
#       source  = "mrparkers/keycloak"
#       version = "4.2.0"
#     }
#   }
# }
# provider "keycloak" {
#   client_id     = "admin-cli"
#   client_secret = "your_admin_cli_client_secret"
#   url           = "http://localhost:8080"
#   realm         = "master"
#   username      = "admin"
#   password      = var.keycloak_admin_password
# }
#
# resource "keycloak_realm" "realm" {
#   realm = "couchtec"
# }
#
# resource "keycloak_openid_client" "client" {
#   realm_id    = keycloak_realm.realm.id
#   client_id   = "oidc-client-id"
#   name        = "APIM Client"
#   description = "Client for Azure API Management"
#
#   access_type              = "CONFIDENTIAL"
#   standard_flow_enabled    = true
#   service_accounts_enabled = true
#
#   valid_redirect_uris = [
#     "https://your_azure_api_management_domain/callback"
#   ]
# }
#
# resource "keycloak_role" "role" {
#   realm_id    = keycloak_realm.realm.id
#   name        = "role"
#   description = "Role for accessing APIs"
# }
