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

