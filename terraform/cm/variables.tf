variable "cloudflare_email" {
  type    = string
  default = "linus@couchtec.com"
}

variable "cloudflare_api_token" {
  type = string
}

variable "domain" {
  type    = string
  default = "linusweigand.com"
}

variable "resource_group_name" {
  type = string
}

variable "cert_manager_version" {
  type    = string
  default = "v1.1.0"
}
