variable "domain" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "cert_manager_version" {
  type    = string
  default = "v1.1.0"
}

variable "email" {
  type = string
}

variable "subscription_id" {
  type = string
}

# variable "cert_manager_identity_client_id" {
#   type = string
# }

variable "cluster_name" {
  type = string
}

variable "node_resource_group" {
  type = string
}

variable "name" {
  type = string
}

variable "namespace" {
  type = string
}
