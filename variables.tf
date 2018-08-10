variable "platform_vpc_id" {}

variable "platform_name" {}

variable "create_internal_zone" {
  description = "Boolean variable which defines weather internal zone will be created or existing will be used"
  default     = false
}

variable "create_external_zone" {
  description = "Boolean variable which defines weather external zone will be created or existing will be used"
  default     = false
}

variable "platform_internal_subdomain" {
  description = "The name of existing or to be created(depends on create_internal_zone variable) internal DNS zone"
  default     = ""
}

variable "platform_external_subdomain" {
  description = "The name of existing or to be created(depends on create_external_zone variable) external DNS zone"
  default     = ""
}

variable "platform_lb_name" {}

variable "platform_lb_zone_id" {}

variable "platform_lb_dns_name" {}

variable "platform_alb_name" {}

variable "platform_alb_zone_id" {}

variable "platform_alb_dns_name" {}

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
