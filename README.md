# CloudAzure
> **Architecture :** Lab de simulation Microsoft Azure Hardened | **Version :** v2.3 | **Maintainer :** [Ravindra JOB](https://github.com/ravindrajob/)
---


# Microsoft Azure : Landing Zone Hardened

Ce dépôt centralise les briques d'infrastructure (IaC) nécessaires au déploiement d'une **Landing Zone** industrielle sur Azure. L'architecture suit les recommandations du **Cloud Adoption Framework (CAF)** de Microsoft et les principes de la **CNCF**.

---

### 🧱 Architecture du Lab

L'infrastructure est découpée en briques logiques permettant une promotion modulaire de l'environnement.

| Module | Fonctionnalité | Hardening Spécifique |
| :--- | :--- | :--- |
| **`Governance`** | Policies & Compliance | Azure Policies (No Public IP), Enforce Private Link, WIF. |
| **`Connectivity`** | Network Hub | Virtual WAN (vWAN), Hub-and-Spoke centralisé. |
| **`Connectivity`** | Hybrid Link | ExpressRoute (Metered), circuit dédié Paris, vWAN Gateway. |
| **`Firewall`** | Perimeter Security | Azure Firewall Premium, inspection TLS, IDPS. |
| **`Bastion`** | Zéro Trust Access | Azure Bastion PaaS pour l'administration sans IP publique. |
| **`Kubernetes`** | Orchestration | AKS Private Cluster, Azure CNI, RBAC Entra ID. |
| **`ReverseProxy`** | Web Exposition | Application Gateway WAF v2, protection OWASP. |
| **`CDN`** | Edge Security | Front Door Premium, accélération et WAF Edge. |
| **`AI-Security`** | AI Agent Proxy | Gateway A2A pour la sécurisation des flux Azure OpenAI. |
| **`ChaosEngineering`** | Fault Injection | Azure Chaos Studio (Node Shutdown / Network Latency). |
| **`FinOps`** | Financial Management | Azure Cost Management, export de données et budgets automatisés. |
| **`SecOps`** | SOC Operations | Microsoft Sentinel (SIEM/SOAR) pour la détection et la remédiation. |

---

### 🛡️ Principes de Sécurité (Security by Design)

- **Identité Moderne :** Bannissement des Client Secrets au profit du Workload Identity Federation (WIF) et des Managed Identities.
- **Accès Privé Systématique :** Utilisation intensive d'Azure Private Link. Aucune ressource PaaS n'est exposée sur Internet.
- **Micro-segmentation :** Utilisation des NSG (Network Security Groups) et filtrage L7 via le Firewall Premium.

### ⚙️ Déploiement & Orchestration

L'orchestration est pilotée par un pipeline GitOps situé dans `.github/workflows/`. Le déploiement s'appuie sur une séquence par couches pour assurer la stabilité du socle d'infrastructure.

---
*Note : Ce dépôt est un environnement de simulation (Lab). Les configurations sont isolées et utilisent exclusivement le domaine `ravindra-job.com`.*
