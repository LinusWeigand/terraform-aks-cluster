variable "name" {
  type        = string
  default     = "linus"
  description = "Name for resources"
}

variable "location" {
  type        = string
  default     = "germanywestcentral"
  description = "Azure Location of resources"
}

variable "network_address_space" {
  type        = string
  description = "Azure VNET Address Space"
}

variable "aks_subnet_address_name" {
  type        = string
  description = "AKS Subnet Address Name"
}

variable "aks_subnet_address_prefix" {
  type        = string
  description = "AKS Subnet Address Space"
}

variable "subnet_address_name" {
  type        = string
  description = "Subnet Address Name"
}

variable "subnet_address_prefix" {
  type        = string
  description = "Subnet Address Space"
}


variable "CLIENT_ID" {
  type = string
}

variable "CLIENT_SECRET" {
  type = string
}

variable "SUBSCRIPTION_ID" {
  type = string
}

variable "TENANT_ID" {
  type = string
}
