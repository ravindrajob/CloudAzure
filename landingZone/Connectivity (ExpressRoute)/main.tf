################################################################
# Titre: Azure ExpressRoute (Hybrid Connectivity)
# Description : Connexion privée haute performance vers le On-Premise
# Auteur: Ravindra JOB
# Source: https://github.com/ravindrajob/
# Update: 22/05/2026 [v1.0 | RJ]
################################################################

# 1. ExpressRoute Circuit (CAF: Connectivity Foundation)
resource "azurerm_express_route_circuit" "er" {
  name                  = "er-lab-circuit"
  resource_group_name   = var.resource_group_name
  location              = var.location
  service_provider_name = "Equinix"
  peering_location      = "Paris"
  bandwidth_in_mbps     = 50
  sku {
    tier   = "Standard"
    family = "MeteredData"
  }

  tags = {
    Environment = "Lab"
    ManagedBy   = "Terraform"
  }
}

# 2. Gateway ExpressRoute rattachée au vWAN Hub
resource "azurerm_express_route_gateway" "gw" {
  name                = "er-gw-lab"
  resource_group_name = var.resource_group_name
  location            = var.location
  virtual_hub_id      = var.virtual_hub_id
  scale_units         = 1
}
