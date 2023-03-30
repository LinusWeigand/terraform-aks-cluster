variable "name" {
  type        = string
  default     = "linus"
  description = "Name for resources
}

variable "location" {
  type        = string
  default     = "germanywestcentral"
  description = "Azure Location of resources"
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

variable "domain" {
  type    = string
  default = "linusweigand.de"
}

variable "email" {
  type    = string
  default = "linus@couchtec.com"
}

variable "resource_group_name" {
  type    = string
  default = "linus-rg"
}

variable "dns_zone_id" {
  type    = string
  default = "/subscriptions/2a70cd88-34b2-4240-9c18-221c1564239d/resourceGroups/linus-rg/providers/Microsoft.Network/dnszones/linusweigand.de"
}
