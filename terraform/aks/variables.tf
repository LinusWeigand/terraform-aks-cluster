variable "resource_group_name" {
  type        = string
  description = "Resource Group Name"
}

variable "kubernetes_version" {
  type = string
}

variable "agent_count" {
  type = string
}

variable "vm_size" {
  type = string
}

variable "ssh_public_key" {
  type = string
}

variable "aks_admins_group_object_id" {
  type = string
}

variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "dns_zone_id" {
  type = string
}

variable "node_resource_group" {
  type = string
}

variable "container_registry_id" {
  type = string
}
