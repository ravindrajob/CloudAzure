################################################################
# Titre: Observability - Alerts & Self-Healing Action Group
# Auteur: Ravindra JOB | v1.3
# Update: 23/05/2026
################################################################

# 1. Action Group (Self-Healing via Azure Automation / Logic Apps)
resource "azurerm_monitor_action_group" "self_healing_ag" {
  name                = "ag-self-healing-lab"
  resource_group_name = var.resource_group_name
  short_name          = "AutoRemed"

  automation_runbook_receiver {
    name                    = "remediate-node-failure"
    automation_account_id   = var.automation_account_id
    runbook_name            = "Restart-FailedAKSNode"
    webhook_resource_id     = var.webhook_id
    is_global_run_as_account = true
    use_common_alert_schema = true
  }
}

# 2. Metric Alert for AKS Node Failure
resource "azurerm_monitor_metric_alert" "aks_node_down" {
  name                = "alert-aks-node-down"
  resource_group_name = var.resource_group_name
  scopes              = [var.aks_cluster_id]
  description         = "Déclenche le Self-Healing lorsqu'un noeud AKS tombe (Chaos ou incident)."
  severity            = 1

  criteria {
    metric_namespace = "Microsoft.ContainerService/managedClusters"
    metric_name      = "node_ready_status"
    aggregation      = "Average"
    operator         = "LessThan"
    threshold        = 1
  }

  action {
    action_group_id = azurerm_monitor_action_group.self_healing_ag.id
  }
}
