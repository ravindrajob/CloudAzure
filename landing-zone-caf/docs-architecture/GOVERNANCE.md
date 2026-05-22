################################################################
# Titre: Azure Governance & OIDC Documentation
# Description : Guide des Azure Policies et du WIF pour le Lab
# Auteur: Ravindra JOB
# Source: https://github.com/ravindrajob/
# Update: 12/09/2025 [v1.0 | RJ] Initial baseline
# Update: 22/11/2025 [v1.1 | RJ] Adding WIF & Private Link enforcement
################################################################

# Gouvernance Azure Hardened

Cette Landing Zone applique les standards du **Microsoft Cloud Adoption Framework (CAF)** pour garantir une infrastructure souveraine et sécurisée.

## 📋 Azure Policies (Hardening)

| Politique | État | Justification Technique |
| :--- | :--- | :--- |
| **Deny Public IP** | **Activé** | Réduction de la surface d'attaque. Toutes les ressources sont privées. |
| **Enforce Private Link** | **Activé** | Sécurisation des données PaaS. Interdiction de l'exposition Internet des services SQL et Storage. |
| **Allowed Regions** | **Activé** | Conformité RGPD (France Central / North Europe uniquement). |

## 🛡️ Identity Zéro Trust (WIF Force)
Nous bannissons l'usage des **Client Secrets** (clés statiques). 
- **Workload Identity Federation (WIF)** : Utilisé pour l'authentification GitHub Actions sans mot de passe.
- **Managed Identities** : Chaque ressource Azure possède sa propre identité système pour accéder au Key Vault ou aux bases de données.

---
*Gouvernance méticuleuse conçue par Ravindra JOB.*
