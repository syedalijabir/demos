resource "aws_route53_zone" "private" {
  name = "internal.com."

  vpc {
    vpc_id = module.vpc_service.vpc_id
  }

  tags = merge(
    local.common_tags,
    {
      Name = "internal-zone"
    },
  )
}

resource "aws_route53_record" "service_dns" {
  name     = "${local.system_key}.internal.com"
  type     = "A"
  zone_id  = aws_route53_zone.private.zone_id

  alias {
    evaluate_target_health = false
    name                   = "${aws_lb.lb.dns_name}"
    zone_id                = "${aws_lb.lb.zone_id}"
  }
}