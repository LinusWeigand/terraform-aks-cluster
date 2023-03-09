variable "domain" {
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
