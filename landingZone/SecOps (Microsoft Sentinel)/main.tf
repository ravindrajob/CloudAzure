################################################################
# Titre: SecOps (Microsoft Sentinel)
# Description : SIEM/SOAR Cloud natif pour le Datacenter Azure
# Auteur: Ravindra JOB | v1.3
# Update: 22/05/2026
################################################################

# 1. Activation de Microsoft Sentinel sur le Log Analytics Workspace
resource "azurerm_log_analytics_solution" "sentinel" {
  solution_name         = "SecurityInsights"
  location              = var.location
  resource_group_name   = var.resource_group_name
  workspace_resource_id = var.workspace_id
  workspace_name        = var.workspace_name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/SecurityInsights"
  }
}

# 2. Data Connector : Azure Activity (Audit Trail)
resource "azurerm_sentinel_log_analytics_workspace_onboarding" "example" {
  workspace_id = var.workspace_id
}
