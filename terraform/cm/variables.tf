variable "cloudflare_email" {
  type    = string
  default = "linus@couchtec.com"
}

variable "cloudflare_api_token" {
  type = string
}

variable "domain" {
  type    = string
  default = "aks.linusweigand.com"
}

variable "resource_group_name" {
  type = string
}

variable "cert_manager_version" {
  type    = string
  default = "v1.1.0"
}

variable "zone_id" {
  type    = string
  default = "dc99a90285a4e54937e4d3d90711a969"
}
