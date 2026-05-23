################################################################
# Titre: Firewall (Azure Firewall Premium)
# Description : Configuration exhaustive (NAT, Proxy, IDPS, TLS Inspection)
# Auteur: Ravindra JOB
# Source: https://github.com/ravindrajob/
# Update: 22/05/2026 [v1.2 | RJ]
################################################################

resource "azurerm_firewall_policy" "hardened" {
  name                = "policy-afw-premium-hardened"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Premium"

  # 1. Protection Périmétrique (CAF Security)
  threat_intelligence_mode = "Deny"
  
  intrusion_detection {
    mode = "Deny" # Mode Prevention (IDPS)
  }

  # 2. TLS Inspection (Proxy sémantique)
  # Requis pour inspecter les flux HTTPS vers les API IA
  tls_certificate {
    key_vault_secret_id = var.key_vault_secret_id
    name                = "lab-azure-firewall-cert"
  }
}

resource "azurerm_firewall_policy_rule_collection_group" "standard_rules" {
  name               = "afw-rule-collection-group"
  firewall_policy_id = azurerm_firewall_policy.hardened.id
  priority           = 500

  # 3. DNAT (Publication de services via IP Publique du FW)
  nat_rule_collection {
    name     = "nat_rules_exposition"
    priority = 100
    action   = "Dnat"
    rule {
      name                = "expose-ai-proxy"
      protocols           = ["TCP"]
      source_addresses    = ["*"]
      destination_address = var.firewall_public_ip
      destination_ports   = ["443"]
      translated_address  = var.ai_foundry_private_ip
      translated_port     = "443"
    }
  }

  # 4. Application Rules (Filtrage FQDN Proxy)
  application_rule_collection {
    name     = "app_rules_egress_global"
    priority = 200
    action   = "Allow"
    rule {
      name = "allow-global-whitelist"
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses  = ["10.0.0.0/8"]
      destination_fqdns = [
        "*.openai.azure.com",
        "api.labs.ravindra-job.com",
        "*.github.com",
        "*.githubusercontent.com",
        "*.microsoft.com",
        "*.ubuntu.com"
      ]
      terminate_tls     = true # Activation de l'inspection Proxy
    }
  }
}
