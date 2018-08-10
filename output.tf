output "master_public_dns" {
  value = "${aws_route53_record.public_master.*.name[0]}"
}

output "master_private_dns" {
  value = "${aws_route53_record.private_master.*.name[0]}"
}
