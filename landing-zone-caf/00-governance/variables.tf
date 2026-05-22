################################################################
# Titre: Azure Governance - Variables
# Description : Variables pour la couche de gouvernance et identité
# Auteur: Ravindra JOB
# Source: https://github.com/ravindrajob/
# Update: 10/09/2025 [v1.0 | RJ]
################################################################

variable "management_group_id" {
  description = "ID du Management Group cible pour les politiques"
  type        = string
}

variable "resource_group_name" {
  description = "RG pour les ressources d'identité"
  type        = string
}

variable "location" {
  type    = string
  default = "francecentral"
}
