################################################################
# Titre: CDN (Front Door) - Observability
# Auteur: Ravindra JOB | v1.3
# Update: 23/05/2026
################################################################

resource "azurerm_monitor_diagnostic_setting" "fd_ds" {
  name                       = "ds-frontdoor"
  target_resource_id         = azurerm_cdn_frontdoor_profile.fd.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "FrontDoorAccessLog"
  }
  enabled_log {
    category = "FrontDoorHealthProbeLog"
  }
  enabled_log {
    category = "FrontDoorWebApplicationFirewallLog"
  }
  
  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
