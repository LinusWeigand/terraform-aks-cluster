variable "location" {
  description = "The Azure location where all resources in this example should be created."
  default     = "germanywestcentral"
}

variable "resource_group" {
  description = "The name of the resource group in which the resources should be created."
  default     = "sandbox"
}

variable "environment" {
  default = "Sandbox"
}

# Virtual Network
variable "network_name" {
  default = "terraform_aks_dev_network"
  type = string
}
variable "network_cidr_block" {
  default = "10.0.0.0/16"
}


# AKS Cluster
variable "agent_count" {
  default = 3
}

variable "cluster_name" {
  default = "myaks"
}

variable "ssh_public_key" {
  default = "~/.ssh/id_rsa.pub"
}

variable "dns_prefix" {
  default = "myaks"
}

variable "node_count" {
  default = 3
}

# Service Principal

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

