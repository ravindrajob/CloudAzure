################################################################
# Titre: Self-Service - Custom FinOps Schedule
# Description: Personnalisation de l'extinction
# Auteur: Ravindra JOB | v2.0
################################################################

# Si l'environnement n'est pas Prod, on applique le schedule défini par le dev
resource "azurerm_automation_schedule" "custom_shutdown" {
  count                   = var.environment != "Prod" ? 1 : 0
  name                    = "sch-shutdown-${var.app_name}"
  resource_group_name     = azurerm_resource_group.app_rg.name
  automation_account_name = data.azurerm_automation_account.central_finops.name
  
  # Conversion du format CRON vers Schedule Automation
  frequency = "Day"
  interval  = 1
  # (Simplification Terraform pour l'exemple)
  start_time = "2026-05-24T20:00:00+02:00"
}
