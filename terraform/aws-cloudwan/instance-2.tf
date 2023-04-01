module "ec2_instance_2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "4.3.0"

  providers =  {
    aws = aws.eu-west-2
  }

  name = "${local.stack_prefix}-instance-1"

  create_spot_instance = true
  spot_price           = "0.60"
  spot_type            = "persistent"

  ami_ssm_parameter      = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.instance_security_group_2.id]
  subnet_id              = module.vpc2.private_subnets[0]
  iam_instance_profile   = aws_iam_instance_profile.private_instance_profile.name

  user_data = templatefile("templates/user-data.sh.tpl", {
      region = local.region2
    }
  )

  tags = merge(
    local.common_tags,
    {
      Name = "${local.stack_prefix}-instance-1"
    },
  )
}

resource "aws_security_group" "instance_security_group_2" {
  name        = "${local.stack_prefix}-sg"
  vpc_id      = module.vpc2.vpc_id

  provider = aws.eu-west-2

  ingress {
    description      = "Rule for ICMP"
    from_port        = -1
    to_port          = -1
    protocol         = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
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
      name = "${local.stack_prefix}-sg"
    },
  )
}