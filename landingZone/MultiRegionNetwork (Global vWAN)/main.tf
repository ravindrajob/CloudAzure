################################################################
# Titre: Multi-Region Network (Global vWAN)
# Description : Architecture Global Hub-and-Spoke (Netflix style)
# Auteur: Ravindra JOB | v2.0
# Update: 23/05/2026
################################################################

resource "azurerm_virtual_wan" "global_vwan" {
  name                = "vwan-global-lab"
  resource_group_name = var.resource_group_name
  location            = "Global"
  type                = "Standard"
}

# Hub Région 1 (France Central)
resource "azurerm_virtual_hub" "hub_france" {
  name                = "vhub-france"
  resource_group_name = var.resource_group_name
  location            = "francecentral"
  virtual_wan_id      = azurerm_virtual_wan.global_vwan.id
  address_prefix      = "10.200.0.0/24"
}

# Hub Région 2 (North Europe - DRP)
resource "azurerm_virtual_hub" "hub_europe" {
  name                = "vhub-europe"
  resource_group_name = var.resource_group_name
  location            = "northeurope"
  virtual_wan_id      = azurerm_virtual_wan.global_vwan.id
  address_prefix      = "10.201.0.0/24"
}

# Le vWAN assure un maillage (mesh) "Any-to-Any" automatique et chiffré
# entre ces Hubs via le backbone Microsoft.
