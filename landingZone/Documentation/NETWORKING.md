################################################################
# Titre: Azure Architecture Réseau (vWAN & Bastion)
# Description : Guide de la topologie Hub & Spoke vWAN
# Auteur: Ravindra JOB
# Source: https://github.com/ravindrajob/
# Update: 15/09/2025 [v1.0 | RJ] Initial topology design
# Update: 24/11/2025 [v1.1 | RJ] Adding Azure Bastion (IAP mode)
################################################################

# Architecture Réseau : Azure vWAN

L'infrastructure réseau repose sur le service **Azure Virtual WAN**, offrant une connectivité centralisée et un routage Any-to-Any hautement disponible.

## 🏗️ Topologie Hub & Spoke
- **Virtual Hub** : Point central hébergeant le pare-feu et les passerelles VPN.
- **VNet Spokes** : Réseaux applicatifs totalement privés (pas de Gateway Internet).

## 🛡️ Administration Sécurisée : Azure Bastion (Zéro Trust)
Conformément à notre vision **Zéro Trust**, nous n'utilisons plus de serveurs de rebond exposés.
- **Accès Natif** : L'administration SSH/RDP se fait directement via le portail Azure ou le CLI, sans adresse IP publique sur les VMs cibles.
- **Port 443 Only** : Seul le trafic HTTPS vers le service Bastion est autorisé depuis Internet.

## 🌐 Firewall Premium & IDPS
Tout le trafic inter-VNet et sortant vers Internet est inspecté par l'**Azure Firewall Premium**.
- **Inspection TLS** : Déchiffrement et analyse sémantique des flux HTTPS.
- **Filtrage FQDN** : Autorisation uniquement pour les domaines nécessaires (ex: `*.ravindra-job.com`).

---
*Architecture réseau industrielle validée par Ravindra JOB.*
