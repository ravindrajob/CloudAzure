################################################################
# Titre: Azure AI-Agent Security Gateway - Variables
# Description : Variables pour le filtrage sémantique IA
# Auteur: Ravindra JOB
# Source: https://github.com/ravindrajob/
# Update: 25/11/2025 [v1.0 | RJ]
################################################################

variable "resource_group_name" {
  type = string
}

variable "location" {
  type    = string
  default = "francecentral"
}

variable "ca_env_id" {
  description = "ID de l'environnement Azure Container Apps"
  type        = string
}
