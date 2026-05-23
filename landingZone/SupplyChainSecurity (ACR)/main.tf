################################################################
# Titre: Supply Chain Security (ACR)
# Description : Registre isolé, accès privé, Defender for Cloud
# Auteur: Ravindra JOB | v2.0
# Update: 23/05/2026
################################################################

resource "azurerm_container_registry" "secure_acr" {
  name                = "crlabsecure${var.random_suffix}"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Premium"
  admin_enabled       = false # Zéro Trust : RBAC Uniquement

  public_network_access_enabled = false
  
  # Chiffrement par clé Key Vault (CMK)
  encryption {
    enabled            = true
    key_vault_key_id   = var.key_vault_key_id
    identity_client_id = var.managed_identity_client_id
  }
}

# Microsoft Defender for Cloud s'occupe nativement du Vulnerability Scanning
# sur les SKU Premium de l'ACR dès qu'une image est poussée.
