variable "platform_vpc_id" {}

variable "platform_name" {}

variable "platform_internal_subdomain" {}

variable "platform_external_subdomain" {
  default = ""
}

variable "platform_lb_name" {}

variable "platform_lb_zone_id" {}

variable "platform_lb_dns_name" {}

variable "master_private_lb_name" {}

variable "master_private_lb_zone_id" {}

variable "master_private_lb_dns_name" {}

variable "master_public_lb_name" {}

variable "master_public_lb_zone_id" {}

variable "master_public_lb_dns_name" {}

variable "tags" {
  type = "map"
}

variable "internet_facing" {
  description = "Define if ELBs for master and infra nodes are internet-facing (exteral or internal)"
}
