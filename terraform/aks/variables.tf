variable "resource_group_name" {
  type        = string
  description = "Resource Group Name"
}

variable "kubernetes_version" {
}

variable "agent_count" {
}

variable "vm_size" {
}

variable "ssh_public_key" {
}

variable "aks_admins_group_object_id" {
}

variable "name" {
}

variable "location" {
}

variable "akssubnet_id" {

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
