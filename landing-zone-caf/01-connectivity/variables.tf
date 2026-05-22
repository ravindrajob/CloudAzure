################################################################
# Titre: Azure Connectivity - Variables
# Description : Variables pour le Hub vWAN et Bastion
# Auteur: Ravindra JOB
# Source: https://github.com/ravindrajob/
# Update: 15/09/2025 [v1.0 | RJ]
################################################################

variable "resource_group_name" {
  type = string
}

variable "location" {
  type    = string
  default = "francecentral"
}
