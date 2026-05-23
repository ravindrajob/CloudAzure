################################################################
# Titre: Firewall Premium - Observability
# Auteur: Ravindra JOB | v1.3
# Update: 23/05/2026
################################################################

resource "azurerm_monitor_diagnostic_setting" "fw_ds" {
  name                       = "ds-azure-firewall"
  target_resource_id         = azurerm_firewall_policy.hardened.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "AzureFirewallApplicationRule"
  }
  enabled_log {
    category = "AzureFirewallNetworkRule"
  }
  enabled_log {
    category = "AzureFirewallDnsProxy"
  }
  enabled_log {
    category = "AzureFirewallThreatIntelLog"
  }
  enabled_log {
    category = "AzureFirewallIdpsSignature"
  }
  
  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
