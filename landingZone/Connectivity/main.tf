################################################################
# Titre: Azure Connectivity (vWAN & Firewall Premium)
# Description : Hub de transit centralisé avec inspection L7 et Bastion (IAP equivalent)
# Auteur: Ravindra JOB
# Source: https://github.com/ravindrajob/
# Update: 15/09/2025 [v1.0 | RJ] Initial vWAN setup
# Update: 24/11/2025 [v1.1 | RJ] Adding Firewall Premium IDPS & Bastion
################################################################

# 1. Virtual WAN (CAF: Connectivity Pillar)
resource "azurerm_virtual_wan" "main_vwan" {
  name                = "lab-azure-vwan"
  resource_group_name = var.resource_group_name
  location            = var.location
  type                = "Standard"
}

resource "azurerm_virtual_hub" "main_hub" {
  name                = "lab-azure-hub"
  resource_group_name = var.resource_group_name
  location            = var.location
  virtual_wan_id      = azurerm_virtual_wan.main_vwan.id
  address_prefix      = "10.100.0.0/24"
}

# 2. Azure Firewall Premium (CNCF: L7 Inspection)
# Offre l'IDPS et l'inspection TLS pour le domaine ravindra-job.com
resource "azurerm_firewall" "hub_fw" {
  name                = "lab-azure-firewall"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "AZFW_Hub"
  sku_tier            = "Premium"
  virtual_hub {
    virtual_hub_id  = azurerm_virtual_hub.main_hub.id
    public_ip_count = 1
  }
}

# 3. Azure Bastion (Zéro Trust Admin)
# Équivalent de l'IAP sur GCP : accès sécurisé sans IP publique.
resource "azurerm_virtual_network" "bastion_vnet" {
  name                = "vnet-bastion-mgmt"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = ["10.100.1.0/24"]
}

resource "azurerm_subnet" "bastion_subnet" {
  name                 = "AzureBastionSubnet" # Nom réservé par Azure
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.bastion_vnet.name
  address_prefixes     = ["10.100.1.0/26"]
}

resource "azurerm_public_ip" "bastion_ip" {
  name                = "pip-bastion"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bastion" {
  name                = "lab-azure-bastion"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.bastion_subnet.id
    public_ip_address_id = azurerm_public_ip.bastion_ip.id
  }
}
