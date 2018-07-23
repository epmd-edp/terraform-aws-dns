variable "platform_vpc_id" {}

variable "platform_name" {}

variable "platform_default_subdomain" {}

variable "platform_lb_zone_id" {}

variable "platform_lb_dns_name" {}

variable "master_dns_name" {}

variable "master_lb_zone_id" {}

variable "master_lb_dns_name" {}

variable "tags" {
  type = "map"
}
