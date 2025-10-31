#!/bin/bash

# ==============================================================================
# TITRE: Installation de la Suite Logicielle "SRV" (Stream Record Virtualisation)
# AUTEUR: Amaury Libert (Base) | Amélioré par l'IA
# LICENCE: GPLv3
# DESCRIPTION:
#   Installation automatisée d'OBS, Quickemu, VirtualBox, KVM/Virt-Manager et
#   VMware Player, ainsi que des outils associés.
# ==============================================================================

# --- Configuration et Préparation ---

# Mode strict: Quitte en cas d'erreur (-e), variable non définie (-u), ou échec
# dans un pipe (-o pipefail).
set -euo pipefail

# Couleurs pour une sortie utilisateur claire
VERT='\033[0;32m'
ROUGE='\033[0;31m'
JAUNE='\033[0;33m'
CYAN='\033[0;36m'
FIN='\033[0m'

# Fichiers et variables
VERSION_VMWARE="16.2.4-20089737"
FICHIER_VMWARE="VMware-Player-Full-${VERSION_VMWARE}.x86_64.bundle"
URL_VMWARE="https://www.dropbox.com/s/m8ln9i8t1ccllew/${FICHIER_VMWARE}?dl=1" # Ajout de ?dl=1 pour le téléchargement direct
CLE_VBOX_KEYRING="/usr/share/keyrings/oracle-virtualbox.gpg"
FICHIER_VBOX_SOURCES="/etc/apt/sources.list.d/virtualbox.list"
DISTRIBUTION_CODENAME="jammy" # Pour Ubuntu 22.04 / Mint 21

# Vérification des droits root
if [ "$(id -u)" -ne 0 ]; then
    echo -e "${ROUGE}ERREUR : Ce script doit être exécuté avec 'sudo' ou en tant que root.${FIN}"
    exit 1
fi

# Déterminer l'utilisateur réel (pour les groupes)
UTILISATEUR_REEL=${SUDO_USER:-$(whoami)}

echo -e "${CYAN}*** Début de l'installation de la Suite SRV ***${FIN}"
clear # Effacement de l'écran

# --- Étape 1: Mises à jour et Prérequis ---

echo -e "${JAUNE}1. Mise à jour des dépôts et installation des prérequis fondamentaux...${FIN}"

# apt-transport-https est implicite, on ajoute curl et les outils de construction pour VMware et KVM
apt update
apt upgrade -y
apt install -y wget curl apt-transport-https gnupg build-essential dkms libglib2.0-0 libx11-6 zlib1g

# --- Étape 2: Ajout des Dépôts Tiers (PPAs et Oracle) ---

echo -e "${JAUNE}2. Ajout des dépôts supplémentaires (OBS, Quickemu, VirtualBox)...${FIN}"

# PPAs (Utilisation de l'outil 'add-apt-repository' standard)
add-apt-repository -y ppa:obsproject/obs-studio
add-apt-repository -y ppa:flexiondotorg/quickemu
add-apt-repository -y ppa:yannick-mauray/quickgui

# NOTE: L'étape 'cp /etc/apt/trusted.gpg /etc/apt/trusted.gpg.d/' est dangereuse et obsolète.
# Les PPAs modernes importent automatiquement les clés dans un fichier dédié dans
# /etc/apt/trusted.gpg.d/ ou /etc/apt/sources.list.d/. Nous la supprimons.

# VirtualBox (Méthode sécurisée avec signed-by)
echo "VirtualBox - Importation de la clé GPG..."
wget -qO-