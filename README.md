################################################################
# Titre: CloudAzure - README
# Description : Lab de simulation Azure Hardened (CAF & CNCF)
# Auteur: Ravindra JOB
# Source: https://github.com/ravindrajob/
# Update: 26/11/2025 [v2.0 | RJ] Major update with Landing Zone CAF
################################################################

# CloudAzure - Lab de Simulation Microsoft Azure

💡 **Philosophie & Partage :** 
Ce dépôt est un laboratoire de démonstration pour les architectures **Microsoft Azure**. Il reflète mon approche méticuleuse et sécurisée de l'infrastructure "Cloud Native". 

Les configurations Terraform ici présentes sont des simulations conçues pour partager des bonnes pratiques sur le domaine **ravindra-job.com**. (OPSEC oblige, mon infrastructure réelle est isolée).

## 🏗️ Architecture du Lab (Landing Zone CAF)

L'infrastructure est modulaire et suit une logique de séparation des responsabilités (**1 dossier = 1 composant**) :

1.  **`landing-zone-caf/00-governance/`** : Verrouillage au niveau Management Group via **Azure Policies** (No Public IPs, WIF Force).
2.  **`landing-zone-caf/01-connectivity/`** : Hub de transit moderne utilisant **Azure Virtual WAN** et **Azure Firewall Premium**.
3.  **`landing-zone-caf/02-spokes/`** : Réseaux applicatifs isolés avec accès PaaS sécurisé via **Azure Private Link**.
4.  **`landing-zone-caf/03-security-a2a/`** : Architecture de gateway de sécurité pour **Azure OpenAI**, implémentant le concept **Action-to-Action (A2A)**.
5.  **`landing-zone-caf/docs-architecture/`** : Documentation industrielle exhaustive (Governance, Networking, Security).

## 🔒 Sécurité par Design
- **Zéro IP Publique** : Utilisation systématique d'**Azure Bastion** pour l'administration.
- **Identité Zéro Trust** : Bannissement des Client Secrets au profit du **Workload Identity Federation (WIF)**.
- **Filtrage L7** : Inspection TLS et IDPS via le pare-feu Premium.

---
*Ce dépôt est maintenu par Ravindra JOB, ingénieur passionné par l'automatisation et la cybersécurité.*
