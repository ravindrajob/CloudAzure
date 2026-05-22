################################################################
# Titre: Azure Sécurité (Defense in Depth)
# Description : Guide de la stratégie Zéro Trust et A2A IA
# Auteur: Ravindra JOB
# Source: https://github.com/ravindrajob/
# Update: 20/09/2025 [v1.0 | RJ] Security baseline
# Update: 26/11/2025 [v1.1 | RJ] Adding A2A IA Security Proxy
################################################################

# Stratégie de Sécurité : Defense in Depth

L'infrastructure applique une stratégie multicouche inspirée du modèle de la **CNCF** et du **Microsoft CAF**.

## 🛡️ Micro-segmentation & NSG
Chaque sous-réseau est protégé par un **Network Security Group (NSG)** avec une règle de priorité maximale bloquant tout le trafic non autorisé.

## 🔒 Azure Private Link (Zéro Public Access)
Toutes les briques PaaS (SQL, Key Vault, OpenAI) sont configurées pour **rejeter tout accès public**. Elles sont accessibles exclusivement via des **Private Endpoints** dans le réseau interne.

## 👤 AI Agent Security (Action-to-Action)
Nous implémentons une gateway de sécurité (A2A) sur Azure OpenAI.
- **Proxy Sémantique** : Analyse des intentions des agents IA pour bloquer les tentatives de contournement de sécurité.
- **Audit Logs** : Chaque interaction agent-modèle est enregistrée et auditée en temps réel.

---
*Vision sécuritaire intransigeante portée par Ravindra JOB.*
