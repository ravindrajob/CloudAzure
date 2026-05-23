################################################################
# Titre: ChaosEngineering - Observability
# Auteur: Ravindra JOB | v1.3
# Update: 23/05/2026
################################################################

# Exporter les logs des expériences de Chaos vers le Log Analytics (LGTM / Azure Monitor)
resource "azurerm_monitor_diagnostic_setting" "chaos_ds" {
  name                       = "ds-chaos-studio"
  target_resource_id         = azurerm_chaos_studio_experiment.aks_failure.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category_group = "allLogs"
  }
}
