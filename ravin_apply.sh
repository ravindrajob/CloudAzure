#!/bin/bash
set -eo pipefail

# ==============================================================================
# Script : ravin_apply.sh
# Description : Wrapper Terraform Sécurisé et Industrialisé
# Auteur : Ravindra JOB | v2.0
# ==============================================================================

# Couleurs et UI
GREEN='\033[1;32m'
BLUE='\033[1;36m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Bannière ASCII "Ravin" et Info
echo -e "${BLUE}"
cat << "EOF"
  _____            _          _____                      
 |  __ \          (_)        / ____|                     
 | |__) |__ ___   _ _ __    | (___   ___  ___ _   _ _ __ 
 |  _  // _` \ \ / / | '_ \    \___ \ / _ \/ __| | | | '__|
 | | \ \ (_| |\ V /| | | | |   ____) |  __/ (__| |_| | |   
 |_|  \_\__,_| \_/ |_|_| |_|  |_____/ \___|\___|\__,_|_|   
                                                           
EOF
echo -e "${NC}"
echo -e "${BOLD}▶ Infrastructure as Code Wrapper | By Ravindra JOB${NC}\n"

# Variables
TF_DIR=${1:-"landingZone"}
ACTION=${2:-"plan"}

if [ ! -d "$TF_DIR" ]; then
    echo -e "${RED}✖ Erreur : Le répertoire cible '$TF_DIR' n'existe pas.${NC}"
    exit 1
fi

echo -e "${YELLOW}⚙️  Initialisation de l'environnement sécurisé...${NC}"
cd "$TF_DIR" || exit

# Verification des pre-requis de securité
if ! command -v terraform &> /dev/null; then
    echo -e "${RED}✖ Erreur : Terraform n'est pas installé.${NC}"
    exit 1
fi

# 1. INIT
echo -e "\n${BLUE}[1/3] Exécution de Terraform Init (Verrouillage State)...${NC}"
terraform init -input=false -no-color | grep -e "Terraform has been successfully initialized" -e "Error" || true

# 2. FORMAT & VALIDATE
echo -e "\n${BLUE}[2/3] Validation syntaxique et Formatage...${NC}"
terraform fmt -check=true || echo -e "${YELLOW}⚠️  Le code n'est pas parfaitement formaté (terraform fmt recommandé).${NC}"
terraform validate -no-color | grep "Success" || true

# 3. PLAN ou APPLY
if [ "$ACTION" == "plan" ]; then
    echo -e "\n${GREEN}[3/3] Génération du Plan d'exécution Zéro Trust...${NC}\n"
    terraform plan -out=tfplan
    echo -e "\n${BOLD}✅ Plan généré. Utilisez './ravin_apply.sh <dossier> apply' pour l'appliquer.${NC}"

elif [ "$ACTION" == "apply" ]; then
    if [ ! -f "tfplan" ]; then
        echo -e "${YELLOW}⚠️  Aucun fichier tfplan trouvé. Exécution d'un plan à la volée...${NC}"
        terraform plan -out=tfplan
    fi
    
    echo -e "\n${GREEN}[3/3] Application de l'infrastructure Cloud Native...${NC}\n"
    read -p "❓ Confirmez-vous le déploiement en production ? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        terraform apply "tfplan"
        echo -e "\n${BOLD}🚀 Infrastructure déployée avec succès (Sécurisée & Opérationnelle).${NC}"
        rm -f tfplan
    else
        echo -e "\n${RED}✖ Déploiement annulé.${NC}"
        rm -f tfplan
    fi
else
    echo -e "${RED}✖ Action inconnue : '$ACTION'. Utilisez 'plan' ou 'apply'.${NC}"
fi
