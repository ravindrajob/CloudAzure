################################################################
# Titre: FinOps - Auto-Shutdown (Non-Prod)
# Auteur: Ravindra JOB | v1.3
# Update: 23/05/2026
################################################################

# Automation Account pour gérer l'extinction
resource "azurerm_automation_account" "finops_aa" {
  name                = "aa-finops-lab"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "Basic"
}

# Runbook PowerShell d'extinction des VMs et AKS "Non-Prod"
resource "azurerm_automation_runbook" "shutdown_nonprod" {
  name                    = "Stop-NonProdResources"
  location                = var.location
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.finops_aa.name
  log_verbose             = true
  log_progress            = true
  runbook_type            = "PowerShell72"

  content = <<-EOT
    # Script d'extinction (Self-Healing FinOps)
    # Cible: Tous les Resource Groups taggés 'Environment=Non-Prod'
    Param()
    $rgs = Get-AzResourceGroup -Tag @{ "Environment"="Non-Prod" }
    foreach ($rg in $rgs) {
        Write-Output "Extinction des VMs dans $($rg.ResourceGroupName)"
        Get-AzVM -ResourceGroupName $rg.ResourceGroupName | Stop-AzVM -Force -NoWait
        Write-Output "Arrêt des clusters AKS dans $($rg.ResourceGroupName)"
        Get-AzAksCluster -ResourceGroupName $rg.ResourceGroupName | Stop-AzAksCluster
    }
  EOT
}

# Planification: Tous les soirs à 20h00
resource "azurerm_automation_schedule" "nightly" {
  name                    = "sch-nightly-shutdown"
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.finops_aa.name
  frequency               = "Day"
  interval                = 1
  start_time              = "2026-05-24T20:00:00+02:00"
}

resource "azurerm_automation_job_schedule" "job" {
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.finops_aa.name
  runbook_name            = azurerm_automation_runbook.shutdown_nonprod.name
  schedule_name           = azurerm_automation_schedule.nightly.name
}
