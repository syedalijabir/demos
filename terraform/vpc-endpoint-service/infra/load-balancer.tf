resource "aws_lb" "lb" {
  name                       = "${local.system_key}-lb"
  internal                   = true
  load_balancer_type         = "network"

  subnets = module.vpc_service.private_subnets

  tags = merge(
    local.common_tags,
    {
      name = "${local.system_key}-lb"
    },
  )
}

resource "aws_lb_target_group" "lb_target_group" {
  name     = "${local.system_key}-tg"
  port     = local.application_port
  protocol = "TCP"
  vpc_id   = module.vpc_service.vpc_id

  target_type = "ip"

  tags = merge(
    local.common_tags,
    {
      name = "${local.system_key}-target-group"
    },
  )
}

resource "aws_lb_listener" "lb_listener" {
  depends_on = [
    aws_lb.lb,
    aws_lb_target_group.lb_target_group
  ]
  load_balancer_arn = aws_lb.lb.arn
    port            = 80
    protocol        = "TCP"

  default_action {
    target_group_arn = aws_lb_target_group.lb_target_group.arn
    type             = "forward"
  }

  tags = merge(
    local.common_tags,
    {
      name = "${local.system_key}-listener"
    },
  )
}
