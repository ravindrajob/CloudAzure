################################################################
# Titre: DNS (Azure Private DNS)
# Description : Maillage Zéro Trust et entrées de simulation Lab
# Auteur: Ravindra JOB
# Source: https://github.com/ravindrajob/
# Update: 22/05/2026 [v1.2 | RJ]
################################################################

# 1. Zone DNS Privée (CAF: DNS Private Resolver Logic)
resource "azurerm_private_dns_zone" "lab_zone" {
  name                = "ravindra-job.com"
  resource_group_name = var.resource_group_name
}

# 2. Liaison physique au VNet (VNet Link)
# Indispensable pour que les ressources du VNet puissent résoudre les noms
resource "azurerm_private_dns_zone_virtual_network_link" "hub_link" {
  name                  = "link-hub-to-dns"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.lab_zone.name
  virtual_network_id    = var.vnet_id
  registration_enabled  = true # Auto-enregistrement des VMs du VNet
}

# 3. Enregistrements DNS de démonstration (Simulation Lab)

resource "azurerm_private_dns_a_record" "app_gateway" {
  name                = "appgw"
  zone_name           = azurerm_private_dns_zone.lab_zone.name
  resource_group_name = var.resource_group_name
  ttl                 = 300
  records             = ["10.100.1.10"] # IP fictive AppGW interne
}

resource "azurerm_private_dns_a_record" "aks_cluster" {
  name                = "aks-api"
  zone_name           = azurerm_private_dns_zone.lab_zone.name
  resource_group_name = var.resource_group_name
  ttl                 = 300
  records             = ["10.1.2.100"] # IP fictive Private Endpoint AKS
}

resource "azurerm_private_dns_cname_record" "openai_privatelink" {
  name                = "openai-endpoint"
  zone_name           = azurerm_private_dns_zone.lab_zone.name
  resource_group_name = var.resource_group_name
  ttl                 = 300
  record              = "privatelink.openai.azure.com" # Redirection vers le Private Link
}
