################################################################
# Titre: Landing Zone Factory (Vending Machine)
# Description : Usine de création de Subscriptions Azure
# Auteur: Ravindra JOB | v2.0
# Update: 23/05/2026
################################################################

# Déploiement industrialisé d'une nouvelle Souscription
resource "azurerm_subscription" "new_landing_zone" {
  subscription_name = "lz-${var.environment}-${var.business_unit}"
  billing_scope_id  = var.billing_account_scope_id
  
  tags = {
    Environment  = var.environment
    BusinessUnit = var.business_unit
    CostCenter   = var.cost_center
  }
}

# Attachement automatique au Management Group correspondant (Governance)
resource "azurerm_management_group_subscription_association" "lz_association" {
  management_group_id = var.target_management_group_id
  subscription_id     = "/subscriptions/${azurerm_subscription.new_landing_zone.subscription_id}"
}
