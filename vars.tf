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
  type    = string
}

# AKS Cluster
variable "aks_service_principal_object_id" {
  description = "Object ID of the service principal."
}

variable "virtual_network_address_prefix" {
  description = "VNET address prefix"
  default     = "192.168.0.0/16"
}

variable "aks_subnet_address_prefix" {
  description = "Subnet address prefix."
  default     = "192.168.0.0/24"
}

variable "app_gateway_subnet_address_prefix" {
  description = "Subnet server IP address."
  default     = "192.168.1.0/24"
}

variable "aks_service_cidr" {
  default = "10.0.0.0/16"
}

variable "aks_dns_service_ip" {
  description = "DNS server IP address"
  default     = "10.0.0.10"
}

variable "aks_docker_bridge_cidr" {
  description = "CIDR notation IP for Docker bridge."
  default     = "172.17.0.1/16"
}

variable "vm_user_name" {
  description = "User name for the VM"
  default     = "vmuser1"
}

variable "agent_count" {
  default = 3
}

variable "cluster_name" {
  default = "myaks"
}

variable "public_ssh_key_path" {
  default = "~/.ssh/id_rsa.pub"
}

variable "tags" {
  type = map(string)

  default = {
    source = "terraform"
  }
}

variable "aks_dns_prefix" {
  default = "cloud"
}

variable "aks_agent_count" {
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

