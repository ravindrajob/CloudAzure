################################################################
# Titre: Azure Firewall Premium & Front Door CDN
# Description : Hub de sécurité périmétrique et CDN Global
# Auteur: Ravindra JOB
# Source: https://github.com/ravindrajob/
# Update: 22/05/2026 [v1.0 | RJ]
################################################################

# 1. Azure Firewall Premium Policy (Hardened)
resource "azurerm_firewall_policy" "fw_policy" {
  name                = "policy-firewall-hardened"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Premium"

  threat_intelligence_mode = "Deny"
  
  intrusion_detection {
    mode = "Deny"
  }
}

# 2. Règles de Pare-feu (Application & Network)
resource "azurerm_firewall_policy_rule_collection_group" "rules" {
  name               = "lab-firewall-rules"
  firewall_policy_id = azurerm_firewall_policy.fw_policy.id
  priority           = 500

  application_rule_collection {
    name     = "app_rules_egress"
    priority = 600
    action   = "Allow"
    rule {
      name = "allow-google-apis"
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses  = ["10.0.0.0/8"]
      destination_fqdns = ["*.googleapis.com", "*.ravindra-job.com"]
    }
  }

  network_rule_collection {
    name     = "net_rules_core"
    priority = 400
    action   = "Allow"
    rule {
      name                  = "allow-dns"
      protocols             = ["UDP"]
      source_addresses      = ["10.0.0.0/8"]
      destination_addresses = ["168.63.129.16"] # Azure DNS
      destination_ports     = ["53"]
    }
  }
}

# 3. Azure Front Door (Standard/Premium CDN)
resource "azurerm_cdn_frontdoor_profile" "fd" {
  name                = "fd-ravindrajob-lab"
  resource_group_name = var.resource_group_name
  sku_name            = "Standard_AzureFrontDoor"
}

resource "azurerm_cdn_frontdoor_endpoint" "endpoint" {
  name                     = "blog-endpoint"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fd.id
}
