resource "aws_security_group" "ecs_security_group" {
  name        = "${local.system_key}-ecs-sg"
  description = "${local.system_key}-ecs-sg"
  vpc_id      = module.vpc_service.vpc_id

  ingress {
    description      = "Rule for ECS service"
    from_port        = 0
    to_port          = local.application_port
    protocol         = "tcp"
    cidr_blocks      = [
      "${local.vpc_service.cidr}"
    ]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(
    local.common_tags,
    {
      name = "${local.system_key}-ecs-sg"
    },
  )
}

resource "aws_security_group" "vpce_security_group" {
  name        = "${local.system_key}-vpce-sg"
  description = "${local.system_key}-vpce-sg"
  vpc_id      = module.vpc_consumer.vpc_id

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(
    local.common_tags,
    {
      name = "${local.system_key}-ec-sg"
    },
  )
}
