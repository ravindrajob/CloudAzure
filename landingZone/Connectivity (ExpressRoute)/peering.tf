################################################################
# Titre: Azure ExpressRoute - Peering & Connections
# Auteur: Ravindra JOB | v1.3
# Update: 23/05/2026
################################################################

# Configuration du Peering Privé (BGP)
resource "azurerm_express_route_circuit_peering" "private_peering" {
  peering_type                  = "AzurePrivatePeering"
  express_route_circuit_name    = azurerm_express_route_circuit.er.name
  resource_group_name           = var.resource_group_name
  peer_asn                      = 65001
  primary_peer_address_prefix   = "10.254.0.0/30"
  secondary_peer_address_prefix = "10.254.0.4/30"
  vlan_id                       = 100
}

# Connexion de l'ExpressRoute à la Gateway du vWAN
resource "azurerm_express_route_connection" "er_connection" {
  name                             = "er-conn-to-vwan"
  express_route_gateway_id         = azurerm_express_route_gateway.gw.id
  express_route_circuit_peering_id = azurerm_express_route_circuit_peering.private_peering.id
  routing_weight                   = 100
}
