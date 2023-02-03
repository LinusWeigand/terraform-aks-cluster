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

variable "cloudflare_email" {
  type    = string
  default = "linus@couchtec.com"
}

variable "cloudflare_api_token" {
  type = string
}

variable "zone_id" {
  type    = string
  default = "dc99a90285a4e54937e4d3d90711a969"
}

variable "domain" {
  type    = string
  default = "aks.linusweigand.com"
}
