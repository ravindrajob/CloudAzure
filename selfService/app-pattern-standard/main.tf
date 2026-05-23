################################################################
# Titre: Self-Service - Azure App Pattern Standard
# Description: Modèle "Golden Path" pour une application Azure
# Auteur: Ravindra JOB | v2.0
################################################################

# 1. Périmètre & Gouvernance
resource "azurerm_resource_group" "app_rg" {
  name     = "rg-${var.app_name}-${lower(var.environment)}"
  location = "francecentral"
  tags = {
    Environment = var.environment
    ManagedBy   = "SelfServicePortal"
    AutoStop    = var.environment == "Prod" ? "False" : "True"
  }
}

# 2. Key Vault (Chiffrement et Secrets par défaut)
resource "azurerm_key_vault" "app_vault" {
  name                       = "kv-${var.app_name}-${lower(var.environment)}"
  location                   = azurerm_resource_group.app_rg.location
  resource_group_name        = azurerm_resource_group.app_rg.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  enable_rbac_authorization  = true
  purge_protection_enabled   = true
  public_network_access_enabled = false
}

# 3. Storage Account Immuable (Logs & Data)
resource "azurerm_storage_account" "app_storage" {
  name                     = "st${replace(var.app_name, "-", "")}${lower(var.environment)}"
  resource_group_name      = azurerm_resource_group.app_rg.name
  location                 = azurerm_resource_group.app_rg.location
  account_tier             = "Standard"
  account_replication_type = var.environment == "Prod" ? "ZRS" : "LRS"
  min_tls_version          = "TLS1_2"
  public_network_access_enabled = false
}

# 4. Identity (Workload Identity Federation)
resource "azurerm_user_assigned_identity" "app_identity" {
  name                = "id-${var.app_name}-${lower(var.environment)}"
  location            = azurerm_resource_group.app_rg.location
  resource_group_name = azurerm_resource_group.app_rg.name
}

# 5. Modules Optionnels (Services à la carte)
module "aks_cluster" {
  source = "../../landingZone/Kubernetes (AKS Private)"
  count  = var.enable_aks ? 1 : 0
  
  resource_group_name = azurerm_resource_group.app_rg.name
  # Hérite des politiques Zéro Trust de la Landing Zone
}

module "ai_foundry" {
  source = "../../landingZone/AISecurity (A2A Proxy)"
  count  = var.enable_ai_foundry ? 1 : 0
  
  resource_group_name = azurerm_resource_group.app_rg.name
}
