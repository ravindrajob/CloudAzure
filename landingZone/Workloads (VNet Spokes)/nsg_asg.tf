################################################################
# Titre: Workloads - NSG & ASG (Micro-segmentation)
# Auteur: Ravindra JOB | v1.3
# Update: 23/05/2026
################################################################

# 1. Application Security Groups (ASG) pour la micro-segmentation
resource "azurerm_application_security_group" "web_asg" {
  name                = "asg-web-tier-lab"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_application_security_group" "db_asg" {
  name                = "asg-db-tier-lab"
  location            = var.location
  resource_group_name = var.resource_group_name
}

# 2. Network Security Group (NSG) avec règles strictes "Deny by Default"
resource "azurerm_network_security_group" "spoke_nsg" {
  name                = "nsg-spoke-prod-lab"
  location            = var.location
  resource_group_name = var.resource_group_name

  # Autorise le trafic entrant depuis l'Application Gateway uniquement vers le tier Web
  security_rule {
    name                                       = "Allow-AppGW-to-Web"
    priority                                   = 100
    direction                                  = "Inbound"
    access                                     = "Allow"
    protocol                                   = "Tcp"
    source_port_range                          = "*"
    destination_port_range                     = "80"
    source_address_prefix                      = "10.0.1.0/24" # AppGW Subnet
    destination_application_security_group_ids = [azurerm_application_security_group.web_asg.id]
  }

  # Autorise le trafic du tier Web vers le tier DB
  security_rule {
    name                                       = "Allow-Web-to-DB"
    priority                                   = 110
    direction                                  = "Inbound"
    access                                     = "Allow"
    protocol                                   = "Tcp"
    source_port_range                          = "*"
    destination_port_range                     = "1433"
    source_application_security_group_ids      = [azurerm_application_security_group.web_asg.id]
    destination_application_security_group_ids = [azurerm_application_security_group.db_asg.id]
  }

  # Blocage explicite (Deny by default géré par Azure, mais on explicite pour l'audit)
  security_rule {
    name                       = "Deny-All-Inbound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# 3. Association du NSG au Subnet
resource "azurerm_subnet_network_security_group_association" "spoke_nsg_assoc" {
  subnet_id                 = azurerm_subnet.prod_app_subnet.id
  network_security_group_id = azurerm_network_security_group.spoke_nsg.id
}

# 4. Observability: NSG Flow Logs vers Storage & Log Analytics
resource "azurerm_network_watcher_flow_log" "spoke_flow_logs" {
  network_watcher_name      = "NetworkWatcher_${var.location}"
  resource_group_name       = "NetworkWatcherRG"
  name                      = "flowlog-spoke-prod"
  network_security_group_id = azurerm_network_security_group.spoke_nsg.id
  storage_account_id        = var.storage_account_id
  enabled                   = true

  retention_policy {
    enabled = true
    days    = 30
  }

  traffic_analytics {
    enabled               = true
    workspace_id          = var.log_analytics_workspace_id
    workspace_region      = var.location
    workspace_resource_id = var.log_analytics_workspace_id
    interval_in_minutes   = 10
  }
}
