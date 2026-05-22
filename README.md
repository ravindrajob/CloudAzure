################################################################
# Titre: CloudAzure - README
# Description : Lab de simulation Microsoft Azure Hardened
# Auteur: Ravindra JOB
# Source: https://github.com/ravindrajob/
# Update: 22/05/2026 [v2.2 | RJ]
################################################################

# Microsoft Azure : Landing Zone Hardened

Ce dépôt centralise les briques d'infrastructure (IaC) nécessaires au déploiement d'une **Landing Zone** industrielle sur Azure. L'architecture suit les recommandations du **Cloud Adoption Framework (CAF)** de Microsoft et les principes de la **CNCF**.

---

### 🧱 Architecture du Lab

L'infrastructure est découpée en briques logiques permettant une promotion modulaire de l'environnement.

| Module | Fonctionnalité | Hardening Spécifique |
| :--- | :--- | :--- |
| **`Governance`** | Policies & Compliance | Azure Policies (No Public IP), Enforce Private Link, WIF. |
| **`Connectivity`** | Network Hub | Virtual WAN (vWAN), Hub-and-Spoke centralisé. |
| **`Firewall`** | Perimeter Security | Azure Firewall Premium, inspection TLS, IDPS. |
| **`Bastion`** | Zéro Trust Access | Azure Bastion PaaS pour l'administration sans IP publique. |
| **`Kubernetes`** | Orchestration | AKS Private Cluster, Azure CNI, RBAC Entra ID. |
| **`ReverseProxy`** | Web Exposition | Application Gateway WAF v2, protection OWASP. |
| **`CDN`** | Edge Security | Front Door Premium, accélération et WAF Edge. |
| **`AI-Security`** | AI Agent Proxy | Gateway A2A pour la sécurisation des flux Azure OpenAI. |

---

### 🛡️ Principes de Sécurité (Security by Design)

- **Identité Moderne :** Bannissement des Client Secrets au profit du Workload Identity Federation (WIF) et des Managed Identities.
- **Accès Privé Systématique :** Utilisation intensive d'Azure Private Link. Aucune ressource PaaS n'est exposée sur Internet.
- **Micro-segmentation :** Utilisation des NSG (Network Security Groups) et filtrage L7 via le Firewall Premium.

### ⚙️ Déploiement & Orchestration

L'orchestration est pilotée par un pipeline GitOps situé dans `.github/workflows/`. Le déploiement s'appuie sur une séquence par couches pour assurer la stabilité du socle d'infrastructure.

---
*Note : Ce dépôt est un environnement de simulation (Lab). Les configurations sont isolées et utilisent exclusivement le domaine `ravindra-job.com`.*
