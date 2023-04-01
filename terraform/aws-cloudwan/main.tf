# Global Network
resource "aws_networkmanager_global_network" "global_network" {
  description = "Global Network"

  tags = merge(
    local.common_tags,
    {
      Name = "global-network"
    },
  )
}

# Core Network
resource "aws_networkmanager_core_network" "core_network" {
  
  description       = "Core Network"
  global_network_id = aws_networkmanager_global_network.global_network.id
  tags = merge(
    local.common_tags,
    {
      Name = "core-network"
    },
  )
}

resource "aws_networkmanager_core_network_policy_attachment" "cn_attachment_policy" {
  core_network_id = aws_networkmanager_core_network.core_network.id
  policy_document = data.aws_networkmanager_core_network_policy_document.cwan_policy.json
}

# Cloud WAN policy
data "aws_networkmanager_core_network_policy_document" "cwan_policy" {
  core_network_configuration {
    vpn_ecmp_support = false
    asn_ranges       = ["64512-64599"]
    edge_locations {
      location = "eu-west-1"
      asn = 64512
    }
    edge_locations {
      location = "eu-west-2"
      asn = 64513
    }
  }

  segments {
    name        = "backbone"
    description = "Network segment for connection between VPCs in multiple regions"

    require_attachment_acceptance = true
  }

  attachment_policies {
    rule_number     = 1000
    condition_logic = "and"

    conditions {
      type     = "tag-value"
      operator = "equals"
      key      = "core-network"
      value    = "enabled"
    }
    conditions {
      type     = "tag-value"
      operator = "equals"
      key      = "segment"
      value    = "backbone"
    }
    action {
      association_method = "tag"
      tag_value_of_key   = "segment"
    }
  }
}