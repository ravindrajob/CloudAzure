################################################################
# Titre: Observability (Azure Monitor)
# Description : Monitoring centralisé et Diagnostic Settings
# Auteur: Ravindra JOB | v1.3
# Update: 22/05/2026
################################################################

resource "azurerm_log_analytics_workspace" "law" {
  name                = "lab-azure-log-analytics"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

# Diagnostic Settings pour l'App Gateway (WAF logs)
resource "azurerm_monitor_diagnostic_setting" "appgw" {
  name                       = "ds-appgw"
  target_resource_id         = var.appgw_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id

  enabled_log {
    category = "ApplicationGatewayAccessLog"
  }
  enabled_log {
    category = "ApplicationGatewayFirewallLog"
  }
}
