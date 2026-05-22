################################################################
# Titre: AKS Private Cluster (Hardened)
# Description : Cluster Kubernetes managé avec Azure CNI et Uptime SLA
# Auteur: Ravindra JOB
# Source: https://github.com/ravindrajob/
# Update: 22/05/2026 [v1.0 | RJ]
################################################################

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "lab-aks-cluster"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "lab-aks"
  sku_tier            = "Standard" # Inclut l'Uptime SLA pour la prod

  # CAF Reference: Zero Trust Identity
  identity {
    type = "SystemAssigned"
  }

  # Sécurité Réseau : Cluster Privé (Zéro IP publique sur les nœuds)
  private_cluster_enabled = true

  default_node_pool {
    name       = "default"
    node_count = 2
    vm_size    = "Standard_DS2_v2"
    vnet_subnet_id = var.subnet_id
    
    # Azure CNI pour des performances réseau natives
    network_plugin = "azure"
  }

  network_profile {
    network_plugin     = "azure"
    load_balancer_sku  = "standard"
    outbound_type      = "userDefinedRouting" # Force le passage par Azure Firewall (Hub)
  }

  # RBAC Azure Intégré
  role_based_access_control_enabled = true
  azure_active_directory_role_based_access_control {
    managed                = true
    admin_group_object_ids = [var.aks_admin_group_id]
  }

  tags = {
    Environment = "Lab"
    ManagedBy   = "Terraform"
  }
}
