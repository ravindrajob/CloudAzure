################################################################
# Titre: Observability (Azure Monitor)
# Description : Monitoring centralisé, AI Safety Audit et Network Watcher
# Auteur: Ravindra JOB
# Source: https://github.com/ravindrajob/
# Update: 22/05/2026 [v1.2 | RJ]
################################################################

# 1. Log Analytics Workspace (CAF: SRE Pillar)
resource "azurerm_log_analytics_workspace" "law" {
  name                = "lab-azure-log-analytics"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

# 2. AI Monitoring : Audit Azure AI Foundry
# Capture des logs de sécurité d'Azure OpenAI (Content Filtering & A2A)
resource "azurerm_monitor_diagnostic_setting" "ai_audit" {
  name                       = "ds-ai-foundry-audit"
  target_resource_id         = var.ai_foundry_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id

  enabled_log {
    category = "Audit"
  }
}

# 3. Network Watcher & Flow Logs (Security by Design)
# Détection des flux suspects et audit de la micro-segmentation
resource "azurerm_network_watcher_flow_log" "flow_logs" {
  network_watcher_name = var.network_watcher_name
  resource_group_name  = var.network_watcher_rg
  name                 = "lab-azure-nsg-flow-logs"

  network_security_group_id = var.nsg_id
  storage_account_id        = var.security_storage_id
  enabled                   = true

  retention_policy {
    enabled = true
    days    = 7
  }

  traffic_analytics {
    enabled               = true
    workspace_id          = azurerm_log_analytics_workspace.law.workspace_id
    workspace_region      = var.location
    workspace_resource_id = azurerm_log_analytics_workspace.law.id
    interval_in_minutes   = 10
  }
}

# 4. Diagnostic Settings pour tous les composants critiques (ExpressRoute, AppGW)
# Garantit que chaque brique de la Landing Zone est instrumentée par défaut.
