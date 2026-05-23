################################################################
# Titre: Self-Service - Azure App Pattern Standard
# Description: Variables d'entrée pour le portail développeur
# Auteur: Ravindra JOB | v2.0
################################################################

variable "app_name" {
  description = "Nom du projet/application (ex: backend-api)"
  type        = string
}

variable "environment" {
  description = "Environnement (Sandbox, Dev, Prod)"
  type        = string
  validation {
    condition     = contains(["Sandbox", "Dev", "Prod"], var.environment)
    error_message = "Doit être Sandbox, Dev, ou Prod."
  }
}

variable "shutdown_schedule" {
  description = "Heure d'extinction quotidienne (CRON format, ex: '0 20 * * *')"
  type        = string
  default     = "0 20 * * *"
}

# Options à la carte (Vending Machine toggles)
variable "enable_aks" {
  description = "Déployer un cluster Kubernetes privé"
  type        = bool
  default     = false
}

variable "enable_database" {
  description = "Déployer une base de données managée (Azure SQL)"
  type        = bool
  default     = false
}

variable "enable_ai_foundry" {
  description = "Attacher l'accès privé à Azure OpenAI"
  type        = bool
  default     = false
}
