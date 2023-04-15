locals {
  system           = "vpc-endpoint-service"
  application_port = "5000"
}

locals {
  system_key = join("-", [
    local.system,
    var.environment
    ]
  )
}

locals {
  common_tags = {
    "owner"       = "syedalijabir"
    "system"      = local.system
    "system-key"  = local.system_key
    "environment" = var.environment
    "managed-by"  = "terraform"
  }

  vpc_service = {
    name = "service-vpc"
    cidr = "172.30.0.0/24"
    network_bits = 3
  }

  vpc_consumer = {
    name = "consumer-vpc"
    cidr = "172.30.1.0/24"
    network_bits = 3
  }
}