################################################################
# Titre: Connectivity (ExpressRoute) - README
# Description : Pourquoi privatiser la liaison hybride
# Auteur: Ravindra JOB
# Source: https://github.com/ravindrajob/
# Update: 22/05/2026 [v1.0 | RJ]
################################################################

# Connectivity (Azure ExpressRoute)

💡 **Rôle du composant :** 
Établir une connexion privée, dédiée et haute performance entre le datacenter On-Premise et Azure, sans passer par l'Internet public.

## Pourquoi ce choix technique ?
**ExpressRoute** est choisi pour garantir une latence minimale et une bande passante stable. Contrairement au VPN S2S, les données ne transitent pas par le Web, réduisant drastiquement le risque d'interception et de congestion.

## Hardening spécifique (vs Standard)
- **Circuit Privé :** Les données circulent sur une fibre dédiée via un partenaire (ex: Equinix).
- **vWAN Integration :** La gateway est directement rattachée au **Virtual Hub**, permettant aux Spokes d'accéder au On-Premise via le routage centralisé du vWAN sans peering maillé.
- **Monitoring :** Activation des métriques de circuit pour détecter toute dégradation de signal à la source.

---
*Architecture hybride validée par Ravindra JOB.*
