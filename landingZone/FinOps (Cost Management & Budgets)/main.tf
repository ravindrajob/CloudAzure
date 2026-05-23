################################################################
# Titre: FinOps (Cost Management & Budgets)
# Description : Export des coûts et alertes budgétaires Azure
# Auteur: Ravindra JOB | v1.3
# Update: 22/05/2026
################################################################

# 1. Budget de souscription (CAF: Financial Governance)
resource "azurerm_consumption_budget_subscription" "lab_budget" {
  name            = "lab-azure-monthly-budget"
  subscription_id = var.subscription_id

  amount     = 200
  time_grain = "Monthly"

  time_period {
    start_date = "2026-01-01T00:00:00Z"
  }

  notification {
    enabled   = true
    threshold = 90.0
    operator  = "EqualTo"
    contact_emails = [
      "admin@ravindra-job.com",
    ]
  }
}

# 2. Export des coûts vers un Storage Account (Analysis)
resource "azurerm_cost_management_export_resource_group" "export" {
  name                = "lab-cost-export"
  resource_group_id   = var.resource_group_id
  storage_container_id = var.storage_container_id

  recurrence_type   = "Monthly"
  recurrence_period = "2026-01-01T00:00:00Z"

  delivery_info {
    storage_account_id = var.storage_account_id
    root_folder_path   = "cost-data"
  }

  query {
    type       = "Usage"
    time_frame = "MonthToDate"
  }
}
