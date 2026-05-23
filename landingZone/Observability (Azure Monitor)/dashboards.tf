################################################################
# Titre: Observability - Dashboards & Workbooks
# Auteur: Ravindra JOB | v1.3
# Update: 23/05/2026
################################################################

resource "azurerm_portal_dashboard" "secops_dashboard" {
  name                = "dashboard-secops-lab"
  resource_group_name = var.resource_group_name
  location            = var.location
  dashboard_properties = jsonencode({
    lenses = {
      0 = {
        order = 0
        parts = {
          0 = {
            position = {
              x = 0
              y = 0
              rowSpan = 4
              colSpan = 6
            }
            metadata = {
              inputs = []
              type = "Extension/HubsExtension/PartType/MarkdownPart"
              settings = {
                content = {
                  settings = {
                    content = "# MTTR & Self-Healing Dashboard\nMonitoring en temps réel des remédiations automatiques."
                  }
                }
              }
            }
          }
        }
      }
    }
  })
}
