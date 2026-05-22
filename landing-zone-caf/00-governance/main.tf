################################################################
# Titre: Azure Governance & OIDC (WIF)
# Description : Imposition du Workload Identity Federation et interdiction des clés statiques
# Auteur: Ravindra JOB
# Source: https://github.com/ravindrajob/
# Update: 10/09/2025 [v1.0 | RJ] Initial governance baseline
# Update: 22/11/2025 [v1.1 | RJ] Enforcing Managed Identity & WIF
################################################################

# 1. Azure Policy : Interdire les adresses IP publiques (CAF: Security)
resource "azurerm_management_group_policy_assignment" "no_public_ip" {
  name                 = "deny-public-ip"
  management_group_id  = var.management_group_id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/83a86541-6215-4a99-80c5-d923e2d236bd"
  display_name         = "Deny Public IP on NICs"
}

# 2. Azure Policy : Forcer l'utilisation de Private Links pour Storage (CNCF: Data Protection)
resource "azurerm_management_group_policy_assignment" "force_private_link" {
  name                 = "enforce-private-link"
  management_group_id  = var.management_group_id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/6db703f5-0691-4475-927a-8ca1d563584d"
  display_name         = "Enforce Private Link for Storage"
}

# 3. Workload Identity Federation (WIF) pour GitHub Actions
# CAF Reference: Secure Identity for Automation
resource "azurerm_user_assigned_identity" "github_actions_identity" {
  name                = "id-github-actions-lab"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags = {
    Environment = "Lab"
    ManagedBy   = "Terraform"
  }
}

resource "azurerm_federated_identity_credential" "github_oidc" {
  name                = "github-oidc-credential"
  resource_group_name = var.resource_group_name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = "https://token.actions.githubusercontent.com"
  parent_id           = azurerm_user_assigned_identity.github_actions_identity.id
  subject             = "repo:ravindrajob/CloudAzure:ref:refs/heads/main"
}
