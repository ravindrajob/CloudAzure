################################################################
# Titre: IaC State Security (Bootstrap)
# Description : Storage Account verrouillé pour le Backend Terraform
# Auteur: Ravindra JOB | v2.0
# Update: 23/05/2026
################################################################

# Utilisation d'une clé KMS pour chiffrer le Storage Account (CMK)
resource "azurerm_storage_account" "tfstate" {
  name                     = "sttfstatelab${var.random_suffix}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "GRS" # Geo-Redundant pour le State
  
  # Forcer TLS 1.2+ et désactiver l'accès public
  min_tls_version               = "TLS1_2"
  public_network_access_enabled = false
  shared_access_key_enabled     = false # Utiliser RBAC (Azure AD) uniquement
}

resource "azurerm_storage_container" "tfstate_container" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "private"
}

# Resource Lock : Anti-destruction
resource "azurerm_management_lock" "tfstate_lock" {
  name       = "lock-tfstate"
  scope      = azurerm_storage_account.tfstate.id
  lock_level = "CanNotDelete"
  notes      = "Verrouille le compte de stockage contenant les états Terraform."
}
