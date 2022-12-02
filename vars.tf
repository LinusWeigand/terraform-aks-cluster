variable "client_secret" {
  description = "Enter your Client Secret. Please make sure you do not store the value of your client secret in the Source-Code-Management repository."
}

variable "client_id" {
  description = "Your client Id."
  default     = "7497c274-3f89-4994-8ef4-9508c19d72ee"
}

variable "subscription_id" {
  description = "Your subscription id."
  default     = "2a70cd88-34b2-4240-9c18-221c1564239d"
}

variable "tenant_id" {
  description = "Your tenant id."
  default     = "b9a54e03-5aaf-479f-ad8c-71b81cf06164"
}

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

}

