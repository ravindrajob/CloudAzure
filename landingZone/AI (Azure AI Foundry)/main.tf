################################################################
# Titre: AI (Azure AI Foundry)
# Description : Infrastructure IA managée (OpenAI, Search, Safety)
# Auteur: Ravindra JOB
# Source: https://github.com/ravindrajob/
# Update: 22/05/2026 [v1.0 | RJ]
################################################################

# 1. Azure AI Services Account (Le moteur)
resource "azurerm_cognitive_account" "ai_foundry" {
  name                = "lab-azure-ai-foundry"
  location            = var.location
  resource_group_name = var.resource_group_name
  kind                = "AIServices" # Azure AI Foundry combine plusieurs services
  sku_name            = "S0"

  # Sécurité Zéro Trust : Pas d'accès public
  public_network_access_enabled = false
  
  # Identity Hardening (WIF/Managed Identity)
  identity {
    type = "SystemAssigned"
  }
}

# 2. Azure AI Search (Indexation vectorielle pour RAG)
resource "azurerm_search_service" "ai_search" {
  name                = "lab-azure-ai-search"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "standard"

  public_network_access_enabled = false
}

# 3. Private Endpoints (Accès via VNet Spoke)
resource "azurerm_private_endpoint" "ai_endpoint" {
  name                = "pe-ai-foundry"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_subnet_id

  private_service_connection {
    name                           = "psc-ai-foundry"
    private_connection_resource_id = azurerm_cognitive_account.ai_foundry.id
    is_manual_connection           = false
    subresource_names              = ["account"]
  }
}

# 4. Exposition via Application Gateway (Reverse Proxy)
# Configuration simulée pour pointer le backend de l'AppGW vers le Private Endpoint
