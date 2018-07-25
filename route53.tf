resource "aws_route53_zone" "private" {
  name   = "${var.platform_internal_subdomain}"
  vpc_id = "${var.platform_vpc_id}"
  tags   = "${merge(var.tags, map("Name", "${var.platform_name}-private"))}"
}

// Configure internal DNS
resource "aws_route53_record" "platform_private" {
  count   = "${var.internet_facing == "external" ? 0 : 1 }"
  zone_id = "${aws_route53_zone.private.zone_id}"
  name    = "*.${var.platform_internal_subdomain}"
  type    = "A"

  alias {
    name                   = "${var.platform_lb_dns_name}"
    zone_id                = "${var.platform_lb_zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "master_private" {
  zone_id = "${aws_route53_zone.private.zone_id}"
  name    = "master.${var.platform_internal_subdomain}"
  type    = "A"

  alias {
    name                   = "${var.master_private_lb_dns_name}"
    zone_id                = "${var.master_private_lb_zone_id}"
    evaluate_target_health = false
  }
}

// Configure external DNS
data "aws_route53_zone" "wildcard_zone" {
  count        = "${var.internet_facing == "external" ? 1 : 0 }"
  name         = "${var.platform_external_subdomain}"
  private_zone = false
}

resource "aws_route53_record" "wildcard_record" {
  count   = "${var.internet_facing == "external" ? 1 : 0 }"
  zone_id = "${data.aws_route53_zone.wildcard_zone.zone_id}"
  name    = "*.${var.platform_name}.${data.aws_route53_zone.wildcard_zone.name}"
  type    = "CNAME"
  ttl     = "300"

  records = [
    "${var.platform_lb_dns_name}",
  ]
}

resource "aws_route53_record" "master_record" {
  count   = "${var.internet_facing == "external" ? 1 : 0 }"
  zone_id = "${data.aws_route53_zone.wildcard_zone.zone_id}"
  name    = "master.${var.platform_name}.${data.aws_route53_zone.wildcard_zone.name}"
  type    = "CNAME"
  ttl     = "300"

  records = [
    "${var.master_public_lb_dns_name}",
  ]
}
