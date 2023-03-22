resource "aws_security_group" "ecs_security_group" {
  name        = "${local.system_key}-ecs-sg"
  description = "${local.system_key}-ecs-sg"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description      = "Rule for ECS service"
    from_port        = 0
    to_port          = local.application_port
    protocol         = "tcp"
    security_groups  = [
      aws_security_group.lb_security_group.id
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

resource "aws_security_group" "lb_security_group" {
  name        = "${local.system_key}-lb-sg"
  description = "${local.system_key}-lb-sg"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description      = "Rule for public access"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [
      "0.0.0.0/0"
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
      name = "${local.system_key}-lb-sg"
    },
  )
}

resource "aws_security_group" "ec_security_group" {
  name        = "${local.system_key}-ec-sg"
  description = "${local.system_key}-ec-sg"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description      = "Rule for EC access"
    from_port        = local.redis_port
    to_port          = local.redis_port
    protocol         = "tcp"
    security_groups  = [
      aws_security_group.ecs_security_group.id
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
      name = "${local.system_key}-ec-sg"
    },
  )
}