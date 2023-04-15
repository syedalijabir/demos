resource "aws_vpc_endpoint_service" "endpoint_service" {
  acceptance_required        = false
  network_load_balancer_arns = [aws_lb.lb.arn]
  # private_dns_name = "${local.system_key}.example.com"

  tags = merge(
    local.common_tags,
    {
      Name = "${local.system_key}-vpces"
    },
  )
}

# resource "aws_route53_record" "vpce_service_verification" {
#   zone_id = aws_route53_zone.private.id
#   name    = aws_vpc_endpoint_service.endpoint_service.private_dns_name_configuration[0].name
#   type    = aws_vpc_endpoint_service.endpoint_service.private_dns_name_configuration[0].type
#   ttl     = "60"
#   records = [aws_vpc_endpoint_service.endpoint_service.private_dns_name_configuration[0].value]
# }

resource "aws_vpc_endpoint" "service_endpoint_for_consumer" {
  vpc_id            = module.vpc_consumer.vpc_id
  service_name      = aws_vpc_endpoint_service.endpoint_service.service_name
  vpc_endpoint_type = "Interface"
  subnet_ids = module.vpc_consumer.private_subnets

  security_group_ids = [
    aws_security_group.vpce_security_group.id,
  ]

  # private_dns_enabled = true

  tags = merge(
    local.common_tags,
    {
      Name = "${local.system_key}-consumer-endpoint"
    },
  )
}