################################################################
# Titre: AKS Module - Variables
# Description : Paramétrage du cluster Kubernetes sur Azure
# Auteur: Ravindra JOB
# Source: https://github.com/ravindrajob/
# Update: 22/05/2026 [v1.0 | RJ]
################################################################

variable "resource_group_name" { type = string }
variable "location" { default = "francecentral" }
variable "subnet_id" { type = string }
variable "aks_admin_group_id" { 
  description = "ID de l'AD Group autorisé à administrer le cluster"
  type        = string
}
