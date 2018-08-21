//Configure Internal DNS
resource "aws_route53_zone" "private_zone" {
  count  = "${var.create_internal_zone ? 1 : 0 }"
  name   = "${var.platform_internal_subdomain}"
  vpc_id = "${var.platform_vpc_id}"
  tags   = "${merge(var.tags, map("Name", "${var.platform_name}-private"))}"
}

data "aws_route53_zone" "private_zone" {
  count        = "${!var.create_internal_zone && var.platform_internal_subdomain != "" ? 1 : 0 }"
  name         = "${var.platform_internal_subdomain}"
  private_zone = true
}

resource "aws_route53_record" "private_wildcard" {
  count   = "${var.create_internal_zone || var.platform_internal_subdomain != "" ? 1 : 0 }"
  zone_id = "${coalesce(join("", data.aws_route53_zone.private_zone.*.zone_id), join("", aws_route53_zone.private_zone.*.zone_id))}"
  name    = "*.${var.platform_name}.${var.platform_internal_subdomain}"
  type    = "A"

  alias {
    name                   = "${var.platform_lb_dns_name}"
    zone_id                = "${var.platform_lb_zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "private_master" {
  count   = "${var.create_internal_zone || var.platform_internal_subdomain != "" ? 1 : 0 }"
  zone_id = "${coalesce(join("", data.aws_route53_zone.private_zone.*.zone_id), join("", aws_route53_zone.private_zone.*.zone_id))}"
  name    = "master.${var.platform_name}.${var.platform_internal_subdomain}"
  type    = "A"

  alias {
    name                   = "${var.master_private_lb_dns_name}"
    zone_id                = "${var.master_private_lb_zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "private_docker_registry_console" {
  count   = "${var.create_internal_zone || var.platform_internal_subdomain != "" ? 1 : 0 }"
  zone_id = "${coalesce(join("", data.aws_route53_zone.private_zone.*.zone_id), join("", aws_route53_zone.private_zone.*.zone_id))}"
  name    = "registry-console-default.${var.platform_name}.${var.platform_internal_subdomain}"
  type    = "A"

  alias {
    name                   = "${var.platform_alb_dns_name}"
    zone_id                = "${var.platform_alb_zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "private_docker_registry" {
  count   = "${var.create_internal_zone || var.platform_internal_subdomain != "" ? 1 : 0 }"
  zone_id = "${coalesce(join("", data.aws_route53_zone.private_zone.*.zone_id), join("", aws_route53_zone.private_zone.*.zone_id))}"
  name    = "docker-registry-default.${var.platform_name}.${var.platform_internal_subdomain}"
  type    = "A"

  alias {
    name                   = "${var.platform_alb_dns_name}"
    zone_id                = "${var.platform_alb_zone_id}"
    evaluate_target_health = false
  }
}

// Configure external DNS
resource "aws_route53_zone" "public_zone" {
  count  = "${var.create_external_zone && var.internet_facing == "external" ? 1 : 0 }"
  name   = "${var.platform_external_subdomain}"
  vpc_id = "${var.platform_vpc_id}"
  tags   = "${merge(var.tags, map("Name", "${var.platform_name}-private"))}"
}

data "aws_route53_zone" "public_zone" {
  count        = "${!var.create_external_zone && var.platform_external_subdomain != 0 && var.internet_facing == "external" ? 1 : 0 }"
  name         = "${var.platform_external_subdomain}"
  private_zone = false
}

resource "aws_route53_record" "public_wildcard" {
  count   = "${(var.create_external_zone || var.platform_internal_subdomain != "") && var.internet_facing == "external" ? 1 : 0 }"
  zone_id = "${coalesce(join("", data.aws_route53_zone.public_zone.*.zone_id), join("", aws_route53_zone.public_zone.*.zone_id))}"
  name    = "*.${var.platform_name}.${var.platform_external_subdomain}"
  type    = "CNAME"
  ttl     = "300"

  records = [
    "${var.platform_lb_dns_name}",
  ]
}

resource "aws_route53_record" "public_master" {
  count   = "${(var.create_external_zone || var.platform_external_subdomain != "") && var.internet_facing == "external" ? 1 : 0 }"
  zone_id = "${coalesce(join("", data.aws_route53_zone.public_zone.*.zone_id), join("", aws_route53_zone.public_zone.*.zone_id))}"
  name    = "master.${var.platform_name}.${var.platform_external_subdomain}"
  type    = "CNAME"
  ttl     = "300"

  records = [
    "${var.master_public_lb_dns_name}",
  ]
}

resource "aws_route53_record" "public_docker_registry_console" {
  count   = "${(var.create_external_zone || var.platform_internal_subdomain != "") && var.internet_facing == "external" ? 1 : 0 }"
  zone_id = "${coalesce(join("", data.aws_route53_zone.public_zone.*.zone_id), join("", aws_route53_zone.public_zone.*.zone_id))}"
  name    = "registry-console-default.${var.platform_name}.${var.platform_external_subdomain}"
  type    = "CNAME"
  ttl     = "300"

  records = [
    "${var.platform_alb_dns_name}",
  ]
}

resource "aws_route53_record" "public_docker_registry" {
  count   = "${(var.create_external_zone || var.platform_internal_subdomain != "") && var.internet_facing == "external" ? 1 : 0 }"
  zone_id = "${coalesce(join("", data.aws_route53_zone.public_zone.*.zone_id), join("", aws_route53_zone.public_zone.*.zone_id))}"
  name    = "docker-registry-default.${var.platform_name}.${var.platform_external_subdomain}"
  type    = "CNAME"
  ttl     = "300"

  records = [
    "${var.platform_alb_dns_name}",
  ]
}
