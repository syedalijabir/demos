locals {
  system           = "simple-app"
  redis_port       = 6379
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
}
