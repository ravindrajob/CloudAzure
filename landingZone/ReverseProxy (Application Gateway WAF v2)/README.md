################################################################
# Titre: ReverseProxy (Application Gateway WAF v2) - README
# Description : Pourquoi Envoy et le WAF sont cruciaux
# Auteur: Ravindra JOB
# Source: https://github.com/ravindrajob/
# Update: 22/05/2026 [v1.1 | RJ]
################################################################

# ReverseProxy (Azure Application Gateway)

💡 **Rôle du composant :** 
Point d'entrée unique et sécurisé pour toutes les applications Web de l'organisation. Il agit comme un pare-feu applicatif (L7).

## Pourquoi ce choix technique ?
L'**Application Gateway v2** est choisie pour son support natif d'**Envoy** (en backend) et son intégration profonde avec Azure Kubernetes Service (AKS) via l'Ingress Controller (AGIC).

## Hardening spécifique (vs Standard)
- **WAF v2 Prevention Mode** : Nous ne sommes pas en mode "Detection". Toute requête suspecte (SQLi, XSS) est **bloquée instantanément**.
- **TLS 1.3 Mandatory** : Désactivation des protocoles obsolètes (TLS 1.0/1.1) pour garantir un chiffrement moderne.
- **End-to-End SSL** : Le trafic est chiffré depuis le client jusqu'au pod Kubernetes, sans rupture de confiance.
- **DDoS Protection Standard** : Couplé à l'AppGW pour encaisser les attaques volumétriques massives.

---
*Standard de sécurisation Web validé par Ravindra JOB.*
