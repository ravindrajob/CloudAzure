################################################################
# Titre: Azure Spokes & Private Link (Security by Design)
# Description : Réseaux applicatifs isolés et accès PaaS privé via Private Link
# Auteur: Ravindra JOB
# Source: https://github.com/ravindrajob/
# Update: 20/09/2025 [v1.0 | RJ] Initial spoke baseline
# Update: 25/11/2025 [v1.1 | RJ] Enforcing Private Endpoint & DNS for ravindra-job.com
################################################################

# 1. Spoke VNet (Environnement Production)
resource "azurerm_virtual_network" "spoke_prod" {
  name                = "vnet-prod-spoke"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "prod_app_subnet" {
  name                 = "snet-prod-app"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.spoke_prod.name
  address_prefixes     = ["10.1.1.0/24"]
}

# 2. Private DNS Zone (ravindra-job.com)
resource "azurerm_private_dns_zone" "internal_dns" {
  name                = "privatelink.ravindra-job.com"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "link" {
  name                  = "link-prod-to-dns"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.internal_dns.name
  virtual_network_id    = azurerm_virtual_network.spoke_prod.id
}

# 3. Private Endpoint pour un Storage Account (Lab de simulation)
resource "azurerm_private_endpoint" "storage_endpoint" {
  name                = "pe-storage-lab"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = azurerm_subnet.prod_app_subnet.id

  private_service_connection {
    name                           = "psc-storage"
    private_connection_resource_id = var.storage_account_id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }

  private_dns_zone_group {
    name                 = "dns-group-storage"
    private_dns_zone_ids = [azurerm_private_dns_zone.internal_dns.id]
  }
}
