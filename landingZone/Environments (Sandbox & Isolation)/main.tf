################################################################
# Titre: Environments (Sandbox & Isolation)
# Auteur: Ravindra JOB | v1.3
# Update: 23/05/2026
################################################################

# La Sandbox est un environnement totalement isolé. Pas de peering vWAN, 
# pas de routage vers la prod, budget agressif indépendant.

resource "azurerm_subscription" "sandbox" {
  subscription_name = "sub-sandbox-isolated-lab"
  billing_scope_id  = var.billing_account_scope_id
}

# Budget agressif exclusif à la Sandbox (Destruction des ressources si dépassé)
resource "azurerm_consumption_budget_subscription" "sandbox_budget" {
  name            = "budget-sandbox-strict"
  subscription_id = azurerm_subscription.sandbox.subscription_id
  amount          = 50
  time_grain      = "Monthly"
  
  time_period {
    start_date = "2026-01-01T00:00:00Z"
  }
  
  notification {
    enabled   = true
    threshold = 100.0
    operator  = "EqualTo"
    contact_emails = ["admin@ravindra-job.com"]
  }
}
