################################################################
# Titre: Governance - SKU Restrictions (FinOps)
# Auteur: Ravindra JOB | v1.3
# Update: 23/05/2026
################################################################

# Interdiction de déployer des VMs ou bases de données hors de prix (G-Series, M-Series, etc.)
resource "azurerm_management_group_policy_assignment" "deny_expensive_skus" {
  name                 = "deny-expensive-vms"
  management_group_id  = var.management_group_id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/cccc23c7-8427-4f53-ad12-b6a63eb452b3"
  display_name         = "Allowed virtual machine size SKUs"
  
  parameters = jsonencode({
    listOfAllowedSKUs = {
      value = [
        "Standard_B2s",
        "Standard_B2ms",
        "Standard_D2s_v3",
        "Standard_D4s_v3"
      ]
    }
  })
}
