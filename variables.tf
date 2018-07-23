variable "platform_vpc_id" {}

variable "platform_name" {}

variable "platform_default_subdomain" {}

variable "platform_lb_arn" {}

variable "master_dns_name" {}

variable "master_lb_arn" {}

variable "tags" {
  type = "map"
}
