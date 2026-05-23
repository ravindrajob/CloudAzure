#!/bin/bash
set -eo pipefail

echo -e "\033[1;34m"
cat << "EOF"
  _____       _  __    _____                 _          
 / ____|     | |/ _|  / ____|               (_)         
| (___   ___ | | |_  | (___   ___ _ ____   ___  ___ ___ 
 \___ \ / _ \| |  _|  \___ \ / _ \ '__\ \ / / |/ __/ _ \
 ____) |  __/| | |    ____) |  __/ |   \ V /| | (_|  __/
|_____/ \___||_|_|   |_____/ \___|_|    \_/ |_|\___\___|
EOF
echo -e "\033[0m"

echo -e "\033[1;36m============================================================\033[0m"
echo -e "\033[1;36m🚀 PORTAIL DÉVELOPPEUR SELF-SERVICE (Vending Machine) 🚀\033[0m"
echo -e "\033[1;36m============================================================\033[0m"
echo -e "Bienvenue ! Configurez votre environnement Azure à la volée :\n"

read -p "1️⃣  Nom de votre application (ex: backend-api) : " APP_NAME
read -p "2️⃣  Environnement (Sandbox, Dev, Prod) : " ENV_NAME

echo -e "\n\033[1;33m--- Services à la carte (Cochez vos besoins) ---\033[0m"
read -p "📦 Ajouter un cluster Kubernetes privé (AKS) ? (y/N) : " AKS_RESP
if [[ $AKS_RESP =~ ^[Yy]$ ]]; then ENABLE_AKS="true"; else ENABLE_AKS="false"; fi

read -p "🗄️  Ajouter une base de données managée (SQL) ? (y/N) : " DB_RESP
if [[ $DB_RESP =~ ^[Yy]$ ]]; then ENABLE_DB="true"; else ENABLE_DB="false"; fi

read -p "🧠 Ajouter l'accès sécurisé à l'IA (Azure Foundry) ? (y/N) : " AI_RESP
if [[ $AI_RESP =~ ^[Yy]$ ]]; then ENABLE_AI="true"; else ENABLE_AI="false"; fi

echo -e "\n\033[1;32m✅ Génération de votre configuration (terraform.tfvars)...\033[0m"

cat <<EOF > terraform.tfvars
app_name          = "${APP_NAME}"
environment       = "${ENV_NAME}"
enable_aks        = ${ENABLE_AKS}
enable_database   = ${ENABLE_DB}
enable_ai_foundry = ${ENABLE_AI}
EOF

echo -e "\033[1;32m✅ Configuration terminée. Lancement de la Landing Zone avec VOTRE identité...\033[0m\n"

# Appel du wrapper central
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)
WRAPPER="$REPO_ROOT/ravin_apply.sh"

if [ -n "$REPO_ROOT" ] && [ -f "$WRAPPER" ]; then
    REL_PATH=${PWD#$REPO_ROOT/}
    cd "$REPO_ROOT"
    ./ravin_apply.sh "$REL_PATH" "apply"
else
    echo -e "\033[1;31m✖ Erreur : Wrapper ravin_apply.sh introuvable à la racine.\033[0m"
    exit 1
fi
