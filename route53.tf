resource "aws_route53_zone" "private" {
  name   = "${var.platform_default_subdomain}"
  vpc_id = "${var.platform_vpc_id}"
  tags   = "${merge(var.tags, map("Name", "${var.platform_name}-private"))}"
}

resource "aws_route53_record" "platform" {
  zone_id = "${aws_route53_zone.private.zone_id}"
  name    = "*.${var.platform_default_subdomain}"
  type    = "A"

  alias {
    name                   = "${var.platform_lb_dns_name}"
    zone_id                = "${var.platform_lb_zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "master" {
  zone_id = "${aws_route53_zone.private.zone_id}"
  name    = "${var.master_dns_name}"
  type    = "A"

  alias {
    name                   = "${var.master_lb_dns_name}"
    zone_id                = "${var.master_lb_zone_id}"
    evaluate_target_health = false
  }
}
