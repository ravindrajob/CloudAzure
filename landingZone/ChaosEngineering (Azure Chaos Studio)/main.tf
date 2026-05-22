################################################################
# Titre: ChaosEngineering (Azure Chaos Studio)
# Description : Injection de fautes managées (Shutdown nodes, Packet loss)
# Auteur: Ravindra JOB | v1.3
# Update: 22/05/2026
################################################################

# 1. Chaos Experiment (CAF: Resilience Pillar)
resource "azurerm_chaos_studio_experiment" "aks_failure" {
  location            = var.location
  name                = "exp-aks-chaos-lab"
  resource_group_name = var.resource_group_name

  selectors {
    id = "selector-aks"
    resource_ids = [var.aks_cluster_id]
  }

  steps {
    name = "step-node-shutdown"
    branches {
      name = "branch-1"
      actions {
        action_type = "continuous"
        # Action : Arrêt brutal des nœuds pour tester le basculement
        urn         = "urn:csci:microsoft:aks:shutdown-nodes/1.0"
        duration    = "PT10M"
        selector_id = "selector-aks"
      }
    }
  }
}
