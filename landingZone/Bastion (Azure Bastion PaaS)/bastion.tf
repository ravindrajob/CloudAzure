################################################################
# Titre: Azure Bastion (Zéro Trust Admin Access)
# Auteur: Ravindra JOB | v1.3
# Update: 23/05/2026
################################################################

resource "azurerm_public_ip" "bastion_pip" {
  name                = "pip-bastion-lab"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Azure Bastion en mode Standard pour supporter le client natif (az network bastion tunnel)
# Aucune IP Publique n'est attachée aux VMs.
resource "azurerm_bastion_host" "bastion" {
  name                = "bastion-lab"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  
  # Tunneling Natif et partage de lien (pour un accès sécure A2A si besoin)
  tunneling_enabled = true
  shareable_link_enabled = false

  ip_configuration {
    name                 = "configuration"
    subnet_id            = var.bastion_subnet_id
    public_ip_address_id = azurerm_public_ip.bastion_pip.id
  }
}
