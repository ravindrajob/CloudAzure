################################################################
# Titre: Documentation Orchestration CI/CD (GitHub Actions)
# Description : Guide sur le déploiement séquentiel de la LZ Azure via WIF
# Auteur: Ravindra JOB
# Source: https://github.com/ravindrajob/
# Update: 22/05/2026 [v1.0 | RJ]
################################################################

# Orchestration du Déploiement : Landing Zone Azure

Pour garantir l'intégrité de l'infrastructure, le déploiement de la Landing Zone Azure suit un pipeline CI/CD industriel basé sur **GitHub Actions**, respectant le principe de **promotion par couches**.

## 🚀 Pipeline de Déploiement (Workflow)

L'orchestration est divisée en "Stages" séquentiels. Chaque couche dépend de la réussite de la précédente pour garantir une cohérence totale de l'infrastructure.

### Séquence de déploiement :
1.  **Stage: Governance (Couche 00)** : Applique les *Azure Policies* (No Public IPs, Private Link Force) et configure les identités fédérées (WIF).
2.  **Stage: Connectivity (Couche 01)** : Déploie le *Virtual WAN Hub*, l'Azure Firewall Premium et le service Bastion.
3.  **Stage: Spokes (Couche 02)** : Crée les VNets isolés et les raccorde au Hub central.
4.  **Stage: AI-Security (Couche 03)** : Déploie le proxy de sécurité (A2A) pour Azure OpenAI.

## 🛡️ Authentification : OIDC & WIF
Conformément aux principes de sécurité **Zéro Trust**, le pipeline n'utilise **aucun Client Secret (clé statique)**. 
- GitHub Actions s'authentifie via le **Workload Identity Federation (WIF)**.
- Azure valide l'identité via un jeton OIDC sécurisé.

## ⚙️ Automatisation
Le fichier de workflow est disponible dans `.github/workflows/deploy-lz.yml`. 

---
