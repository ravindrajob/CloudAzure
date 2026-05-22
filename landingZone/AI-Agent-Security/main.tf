################################################################
# Titre: Azure AI-Agent Security Gateway (A2A)
# Description : Proxy de sécurité pour Azure OpenAI (Filtre sémantique)
# Auteur: Ravindra JOB
# Source: https://github.com/ravindrajob/
# Update: 25/11/2025 [v1.0 | RJ] Initial AI Security Proxy
################################################################

# 1. Managed Identity pour le Proxy (Zéro Trust Identity)
resource "azurerm_user_assigned_identity" "ai_proxy_id" {
  name                = "id-ai-security-proxy-lab"
  resource_group_name = var.resource_group_name
  location            = var.location
}

# 2. Azure OpenAI Account (Simulation)
resource "azurerm_cognitive_account" "openai" {
  name                = "lab-azure-openai"
  location            = var.location
  resource_group_name = var.resource_group_name
  kind                = "OpenAI"
  sku_name            = "S0"
  
  # Sécurité : Pas d'accès public
  public_network_access_enabled = false
}

# 3. Cloud Proxy sur Azure Container Apps (A2A Gateway)
# Ce proxy intercepte les requêtes des agents IA pour valider les actions.
resource "azurerm_container_app" "ai_gateway" {
  name                         = "ca-ai-security-gateway"
  container_app_environment_id = var.ca_env_id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.ai_proxy_id.id]
  }

  template {
    container {
      name   = "ai-security-proxy"
      image  = "ghcr.io/ravindrajob/azure-ai-proxy:latest"
      cpu    = 0.5
      memory = "1Gi"
      
      env {
        name  = "SECURITY_LEVEL"
        value = "hardened"
      }
      env {
        name  = "OPENAI_ENDPOINT"
        value = azurerm_cognitive_account.openai.endpoint
      }
    }
  }
}

# 4. IAM : Autoriser le Proxy à appeler OpenAI uniquement
resource "azurerm_role_assignment" "proxy_to_openai" {
  scope                = azurerm_cognitive_account.openai.id
  role_definition_name = "Cognitive Services OpenAI User"
  principal_id         = azurerm_user_assigned_identity.ai_proxy_id.principal_id
}
