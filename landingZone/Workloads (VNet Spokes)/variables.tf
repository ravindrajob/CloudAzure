################################################################
# Titre: Azure Spokes - Variables
# Description : Variables pour les réseaux applicatifs et Private Endpoints
# Auteur: Ravindra JOB
# Source: https://github.com/ravindrajob/
# Update: 20/09/2025 [v1.0 | RJ]
################################################################

variable "resource_group_name" {
  type = string
}

variable "location" {
  type    = string
  default = "francecentral"
}

variable "storage_account_id" {
  description = "ID de la ressource cible pour le Private Link"
  type        = string
}
