################################################################
# Titre: Data Resilience (Azure Recovery Services)
# Description : Vault immuable (Anti-Ransomware)
# Auteur: Ravindra JOB | v2.0
# Update: 23/05/2026
################################################################

resource "azurerm_recovery_services_vault" "immutable_vault" {
  name                = "rsv-immutable-lab"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  
  storage_mode_type   = "GeoRedundant"
  
  # Chiffrement via CMK
  encryption {
    key_id                            = var.key_vault_key_id
    infrastructure_encryption_enabled = true
    use_system_assigned_identity      = true
  }
}

# Activation de l'immutabilité pour bloquer la suppression des points de restauration
resource "azapi_update_resource" "enable_immutability" {
  type      = "Microsoft.RecoveryServices/vaults@2023-01-01"
  resource_id = azurerm_recovery_services_vault.immutable_vault.id

  body = jsonencode({
    properties = {
      securitySettings = {
        immutabilitySettings = {
          state = "Locked"
        }
      }
    }
  })
}
