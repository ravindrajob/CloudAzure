################################################################
# Titre: Azure AISecurity - AI Foundry & APIM
# Auteur: Ravindra JOB | v1.3
# Update: 23/05/2026
################################################################

# API Management (A2A Gateway)
# Intercepte, limite le rate (Rate Limiting) et loggue les flux vers l'API OpenAI
resource "azurerm_api_management" "a2a_gateway" {
  name                = "apim-a2a-lab"
  location            = var.location
  resource_group_name = var.resource_group_name
  publisher_name      = "Ravindra JOB"
  publisher_email     = "admin@ravindra-job.com"

  sku_name = "Developer_1"

  virtual_network_type = "Internal"
  virtual_network_configuration {
    subnet_id = var.apim_subnet_id
  }
}

# Azure OpenAI (AI Foundry) - Consommé uniquement via APIM
resource "azurerm_cognitive_account" "openai" {
  name                  = "cog-openai-lab"
  location              = var.location
  resource_group_name   = var.resource_group_name
  kind                  = "OpenAI"
  sku_name              = "S0"
  
  public_network_access_enabled = false
}

# Private Endpoint pour Azure OpenAI
resource "azurerm_private_endpoint" "openai_pe" {
  name                = "pe-openai-lab"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "psc-openai"
    private_connection_resource_id = azurerm_cognitive_account.openai.id
    is_manual_connection           = false
    subresource_names              = ["account"]
  }
}
