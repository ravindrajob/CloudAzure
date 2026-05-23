################################################################
# Titre: Secret Orchestration (AKS CSI Driver)
# Description : Synchronisation des secrets Key Vault vers AKS
# Auteur: Ravindra JOB | v2.0
# Update: 23/05/2026
################################################################

# Déploiement de la configuration pour le "Secrets Store CSI Driver"
# Le secret reste dans le Key Vault, le Pod s'authentifie via Workload Identity (WIF)

resource "kubernetes_manifest" "secret_provider_class" {
  manifest = {
    "apiVersion" = "secrets-store.csi.x-k8s.io/v1"
    "kind"       = "SecretProviderClass"
    "metadata" = {
      "name"      = "azure-kv-provider"
      "namespace" = "application-tier"
    }
    "spec" = {
      "provider" = "azure"
      "parameters" = {
        "usePodIdentity" = "false"
        "useVMManagedIdentity" = "false"
        "clientID" = var.workload_identity_client_id
        "keyvaultName" = var.keyvault_name
        "objects" = <<-EOT
          array:
            - |
              objectName: db-connection-string
              objectType: secret
              objectVersion: ""
        EOT
        "tenantId" = var.tenant_id
      }
    }
  }
}
