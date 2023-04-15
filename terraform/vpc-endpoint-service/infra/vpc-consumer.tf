module "vpc_consumer" {
  source = "terraform-aws-modules/vpc/aws"
  version = "3.19.0"

  name = local.vpc_consumer.name
  cidr = local.vpc_consumer.cidr
  azs  = [
    "${var.region}a",
    "${var.region}b",
    "${var.region}c"
  ]

  private_subnets = [
    cidrsubnet(local.vpc_consumer.cidr, local.vpc_consumer.network_bits, 0),
    cidrsubnet(local.vpc_consumer.cidr, local.vpc_consumer.network_bits, 1),
    cidrsubnet(local.vpc_consumer.cidr, local.vpc_consumer.network_bits, 2)
  ]

  public_subnets = [
    cidrsubnet(local.vpc_consumer.cidr, local.vpc_consumer.network_bits, 3),
    cidrsubnet(local.vpc_consumer.cidr, local.vpc_consumer.network_bits, 4),
    cidrsubnet(local.vpc_consumer.cidr, local.vpc_consumer.network_bits, 5)
  ]

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false
  enable_vpn_gateway     = false
  enable_dns_hostnames   = true

  tags = merge(
    local.common_tags,
    {
      Name = "${local.vpc_consumer.name}"
      CIDR = "${local.vpc_consumer.cidr}"
    },
  )
}

