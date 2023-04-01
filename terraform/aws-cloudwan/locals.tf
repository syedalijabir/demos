locals {
  stack_prefix = "aws-cloudwan-demo"
  region1 = "eu-west-1"
  region2 = "eu-west-2"

  common_tags = {
    "owner"       = "syedalijabir"
    "environment" = "demo"
    "managed-by"  = "terraform"
  }
}

locals {
  vpc1 = {
    name = "${local.stack_prefix}-${local.region1}-vpc"
    cidr = "172.30.0.0/24"
    network_bits = 3
  }

  vpc2 = {
    name = "${local.stack_prefix}-${local.region2}-vpc"
    cidr = "172.30.1.0/24"
    network_bits = 3
  }
}
