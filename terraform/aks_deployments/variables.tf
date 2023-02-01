variable "name" {
  type = string
}

variable "location" {
  type = string
}
variable "cloudflare_email" {
  type    = string
  default = "linus@couchtec.com"
}

variable "cloudflare_api_token" {
  type = string
}
