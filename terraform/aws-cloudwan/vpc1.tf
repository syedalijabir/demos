module "vpc1" {
  source = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = local.vpc1.name
  cidr = local.vpc1.cidr
  azs  = [
    "${local.region1}a",
    "${local.region1}b",
    "${local.region1}c"
  ]

  private_subnets = [
    cidrsubnet(local.vpc1.cidr, local.vpc1.network_bits, 0),
    cidrsubnet(local.vpc1.cidr, local.vpc1.network_bits, 1),
    cidrsubnet(local.vpc1.cidr, local.vpc1.network_bits, 2)
  ]

  public_subnets = [
    cidrsubnet(local.vpc1.cidr, local.vpc1.network_bits, 3),
    cidrsubnet(local.vpc1.cidr, local.vpc1.network_bits, 4),
    cidrsubnet(local.vpc1.cidr, local.vpc1.network_bits, 5)
  ]

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false
  enable_vpn_gateway     = false
  enable_dns_hostnames   = true

  tags = merge(
    local.common_tags,
    {
      Name = "${local.vpc1.name}"
      CIDR = "${local.vpc1.cidr}"
    },
  )
}

resource "aws_networkmanager_vpc_attachment" "vpc1_attachment" {
  subnet_arns     = module.vpc1.private_subnet_arns
  core_network_id = aws_networkmanager_core_network.core_network.id
  vpc_arn         = module.vpc1.vpc_arn
  tags = merge(
    local.common_tags,
    {
      Name = "${local.vpc1.name}"
      core-network = "enabled"
      segment = "backbone"
    },
  )
}

resource "aws_route" "vpc1_core_network_route" {
  for_each = {
    for ind, val in module.vpc1.private_route_table_ids: ind => val
  }
  
  route_table_id = each.value
  destination_cidr_block = local.vpc2.cidr
  core_network_arn = aws_networkmanager_core_network.core_network.arn
}

resource "aws_networkmanager_attachment_accepter" "vpc1" {
  attachment_id   = aws_networkmanager_vpc_attachment.vpc1_attachment.id
  attachment_type = aws_networkmanager_vpc_attachment.vpc1_attachment.attachment_type
}