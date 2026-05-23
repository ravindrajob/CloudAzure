#!/bin/bash
set -eo pipefail

# ==============================================================================
# Script local de déploiement (Starter)
# ==============================================================================

ACTION=${1:-"plan"}
MODULE_DIR=$(basename "$PWD")

echo -e "\033[1;36m▶ Préparation du module : $MODULE_DIR\033[0m"

# Recherche du wrapper central à la racine du dépôt git
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)
WRAPPER="$REPO_ROOT/ravin_apply.sh"

if [ -n "$REPO_ROOT" ] && [ -f "$WRAPPER" ]; then
    # Calcul du chemin relatif
    REL_PATH=${PWD#$REPO_ROOT/}
    cd "$REPO_ROOT"
    ./ravin_apply.sh "$REL_PATH" "$ACTION"
else
    echo -e "\033[1;31m✖ Erreur : Wrapper ravin_apply.sh introuvable à la racine.\033[0m"
    exit 1
fi
