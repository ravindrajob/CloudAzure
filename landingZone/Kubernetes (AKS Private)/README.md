################################################################
# Titre: AKS Hardened - Documentation
# Description : Guide de déploiement Kubernetes sur Azure (CAF)
# Auteur: Ravindra JOB
# Source: https://github.com/ravindrajob/
# Update: 22/05/2026 [v1.0 | RJ]
################################################################

# AKS Private Cluster (Hardened)

💡 **Philosophie : Defense in Depth**
Cette infrastructure déploie un cluster Azure Kubernetes Service (AKS) conforme au **Microsoft CAF**. Le cluster est privé, ce qui signifie que l'API Server n'est accessible que via un Private Endpoint interne, et les nœuds n'ont aucune exposition publique.

## Bonnes Pratiques Appliquées (CAF)

- **Azure CNI :** Chaque pod reçoit une adresse IP du VNet, permettant une communication directe et performante avec les autres services privés (Azure SQL, Storage).
- **Zéro IP Publique :** L'administration s'effectue via un Bastion ou un VPN. La sortie Internet est forcée via l'Azure Firewall du Hub (`outbound_type = userDefinedRouting`).
- **Identity Hardening :** Utilisation de l'identité système managée et intégration avec Entra ID (Azure AD) pour le contrôle d'accès RBAC.
- **Uptime SLA :** Configuration en SKU "Standard" pour garantir une disponibilité de 99.95% sur le Control Plane.

## Déploiement de l'Application Demo
Les manifests de l'application de démonstration sont disponibles dans le dossier `app-demo-manifests/` :
```bash
az aks get-credentials --resource-group lab-rg --name lab-aks-cluster
kubectl apply -f app-demo-manifests/
```
---
Adoption industrialisée du CAF avec surcouche de sécurité et intégration des pratiques CNCF.
