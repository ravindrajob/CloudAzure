################################################################
# Titre: Azure DataSecurity - Key Vault & Private Link
# Auteur: Ravindra JOB | v1.3
# Update: 23/05/2026
################################################################

resource "azurerm_key_vault" "lab_kv" {
  name                        = "kv-sec-lab-${var.random_suffix}"
  location                    = var.location
  resource_group_name         = var.resource_group_name
  enabled_for_disk_encryption = true
  tenant_id                   = var.tenant_id
  soft_delete_retention_days  = 30
  purge_protection_enabled    = true

  sku_name = "standard"

  # Zéro Trust : RBAC utilisé au lieu des access policies traditionnelles
  enable_rbac_authorization = true

  # Refus de l'accès public
  public_network_access_enabled = false
}

resource "azurerm_private_endpoint" "kv_pe" {
  name                = "pe-keyvault-lab"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "psc-keyvault"
    private_connection_resource_id = azurerm_key_vault.lab_kv.id
    is_manual_connection           = false
    subresource_names              = ["vault"]
  }
}
