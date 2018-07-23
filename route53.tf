data "aws_elb" "master_lb" {
  name = "${var.master_lb_arn}"
}

data "aws_elb" "platform_lb" {
  name = "${var.platform_lb_arn}"
}

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
    name                   = "${data.aws_elb.platform_lb.dns_name}"
    zone_id                = "${data.aws_elb.platform_lb.zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "master" {
  zone_id = "${aws_route53_zone.private.zone_id}"
  name    = "${var.master_dns_name}"
  type    = "A"

  alias {
    name                   = "${data.aws_elb.master_lb.dns_name}"
    zone_id                = "${data.aws_elb.master_lb.zone_id}"
    evaluate_target_health = false
  }
}
