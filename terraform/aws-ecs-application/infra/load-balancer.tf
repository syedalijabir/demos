resource "aws_lb" "lb" {
  name                       = "${local.system_key}-lb"
  internal                   = false
  load_balancer_type         = "application"
  enable_http2               = true
  enable_deletion_protection = false
  preserve_host_header       = true

  subnets = module.vpc.public_subnets
  security_groups = [
    aws_security_group.lb_security_group.id
  ]

  tags = merge(
    local.common_tags,
    {
      name = "${local.system_key}-lb"
    },
  )
}

resource "aws_lb_target_group" "lb_target_group" {
  name     = "${local.system_key}-target-group"
  port     = local.application_port
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 120
    matcher             = "200"
    path                = "/healthz"
    timeout             = 10
    unhealthy_threshold = 3
  }

  target_type                   = "ip"
  load_balancing_algorithm_type = "least_outstanding_requests"
  preserve_client_ip = true

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
  port              = "80"
  protocol          = "HTTP"

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
