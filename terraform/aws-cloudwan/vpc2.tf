module "vpc2" {
  providers =  {
    aws = aws.eu-west-2
  }

  source = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = local.vpc2.name
  cidr = local.vpc2.cidr
  azs  = [
    "${local.region2}a",
    "${local.region2}b",
    "${local.region2}c"
  ]

  private_subnets = [
    cidrsubnet(local.vpc2.cidr, local.vpc2.network_bits, 0),
    cidrsubnet(local.vpc2.cidr, local.vpc2.network_bits, 1),
    cidrsubnet(local.vpc2.cidr, local.vpc2.network_bits, 2)
  ]

  public_subnets = [
    cidrsubnet(local.vpc2.cidr, local.vpc2.network_bits, 3),
    cidrsubnet(local.vpc2.cidr, local.vpc2.network_bits, 4),
    cidrsubnet(local.vpc2.cidr, local.vpc2.network_bits, 5)
  ]

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false
  enable_vpn_gateway     = false
  enable_dns_hostnames   = true

  tags = merge(
    local.common_tags,
    {
      Name = "${local.vpc2.name}"
      CIDR = "${local.vpc2.cidr}"
    },
  )
}

resource "aws_networkmanager_vpc_attachment" "vpc2_attachment" {
  provider = aws.eu-west-2
  subnet_arns     = module.vpc2.private_subnet_arns
  core_network_id = aws_networkmanager_core_network.core_network.id
  vpc_arn         = module.vpc2.vpc_arn
  tags = merge(
    local.common_tags,
    {
      Name = "${local.vpc2.name}"
      core-network = "enabled"
      segment = "backbone"
    },
  )
}

resource "aws_route" "vpc2_core_network_route" {
  provider = aws.eu-west-2
  
  for_each = {
    for ind, val in module.vpc2.private_route_table_ids: ind => val
  }
  
  route_table_id = each.value
  destination_cidr_block = local.vpc1.cidr
  core_network_arn = aws_networkmanager_core_network.core_network.arn
}

resource "aws_networkmanager_attachment_accepter" "vpc2" {
  provider = aws.eu-west-2
  attachment_id   = aws_networkmanager_vpc_attachment.vpc2_attachment.id
  attachment_type = aws_networkmanager_vpc_attachment.vpc2_attachment.attachment_type
}
