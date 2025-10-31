#!/bin/bash

# ==============================================================================
# TITRE: Installation de la Suite Logicielle "SRV" (Stream Record Virtualisation)
# AUTEUR: Amaury Libert (Base) | Amélioré par l'IA
# LICENCE: GPLv3
# DESCRIPTION:
#   Installation automatisée d'OBS, Quickemu, VirtualBox, KVM/Virt-Manager et
#   VMware Workstation (Bundle), ainsi que des outils associés.
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
FICHIER_VMWARE="VMware-Workstation-Full-${VERSION_VMWARE}.x86_64.bundle"
URL_VMWARE="https://www.dropbox.com/s/4ecjcn38z2xpq8o/${FICHIER_VMWARE}?dl=1" # URL de Dropbox
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

echo -e "${CYAN}*** Début de l'installation de la Suite SRV (avec VMware Workstation) ***${FIN}"
clear # Effacement de l'écran

# --- Étape 1: Mises à jour et Prérequis ---

echo -e "${JAUNE}1. Mise à jour des dépôts et installation des prérequis fondamentaux...${FIN}"

apt update
apt upgrade -y
# Ajout des dépendances pour Virtualisation/Compilation/Bundle VMware
apt install -y wget curl apt-transport-https gnupg build-essential dkms libglib2.0-0 libx11-6 zlib1g

# --- Étape 2: Ajout des Dépôts Tiers (PPAs et Oracle) ---

echo -e "${JAUNE}2. Ajout des dépôts supplémentaires (OBS, Quickemu, VirtualBox)...${FIN}"

# PPAs (Utilisation de l'outil 'add-apt-repository' standard)
add-apt-repository -y ppa:obsproject/obs-studio
add-apt-repository -y ppa:flexiondotorg/quickemu
add-apt-repository -y ppa:yannick-mauray/quickgui

# NOTE: L'étape de copie /etc/apt/trusted.gpg est dangereuse et obsolète, elle a été retirée.

# VirtualBox (Méthode sécurisée avec signed-by)
echo "VirtualBox - Importation de la clé GPG (2016)..."
wget -qO- https://www.virtualbox.org/download/oracle_vbox_2016.asc | gpg --dearmor > "${CLE_VBOX_KEYRING}"

echo "VirtualBox - Ajout du dépôt..."
echo "deb [arch=amd64 signed-by=${CLE_VBOX_KEYRING}] http://download.virtualbox.org/virtualbox/debian ${DISTRIBUTION_CODENAME} contrib" > "${FICHIER_VBOX_SOURCES}"

# Rafraîchissement après tous les ajouts de dépôts
echo "Rafraîchissement des dépôts APT..."
apt update

# --- Étape 3: Installation des Logiciels ---

echo -e "${JAUNE}3. Installation des suites logicielles (Streaming/Vidéo/Virtu)...${FIN}"

# Liste des paquets consolidée (inclut KVM/libvirt-daemon-system pour remplacer libvirt0)
PAQUETS_SRV=(
    ffmpeg
    obs-studio
    quickemu
    quickgui
    virtualbox-7.0 # Version 7.0
    # KVM/QEMU (version améliorée et recommandée)
    qemu
    qemu-kvm
    libvirt-daemon-system
    virt-manager
    python3-guestfs
    libguestfs-tools
    ovmf
    bridge-utils
    gnome-boxes
    # Utilitaires Média & Surveillance
    papirus-icon-theme
    arc-theme
    htop
    nmon
    neofetch
    zram-tools
    audacity
    kdenlive
    diodon
    simplescreenrecorder
    # SSH
    openssh-server
    ssh-askpass
    ssh-askpass-gnome
)

printf '%s\n' "${PAQUETS_SRV[@]}" | xargs apt install -y -o 'apt::install-recommends=true'

if [ $? -ne 0 ]; then
    echo -e "${ROUGE}ERREUR : L'installation APT a échoué. Abandon.${FIN}"
    exit 1
fi
echo -e "${VERT}Suite SRV installée via APT.${FIN}"

# --- Étape 4: Configuration VirtualBox (Extension Pack) ---

echo -e "${JAUNE}4. Configuration de VirtualBox (Extension Pack)...${FIN}"

# Déterminer la version installée et la simplifier
VERSION_VBOX=$(VBoxManage --version 2>/dev/null | cut -dr -f1 | cut -d'_' -f1 || echo "7.0") # Fallback à 7.0
EXTENSION_PACK="Oracle_VM_VirtualBox_Extension_Pack-${VERSION_VBOX}.vbox-extpack"

echo "Téléchargement du Pack d'Extension pour la version ${VERSION_VBOX}..."
wget -c "http://download.virtualbox.org/virtualbox/${VERSION_VBOX}/${EXTENSION_PACK}"

echo "Installation du Pack d'Extension..."
echo -e "${CYAN}!!! ATTENTION : La licence d'Oracle va s'afficher. Acceptez avec 'y' après 3 secondes. !!!${FIN}"
sleep 3
echo "y" | VBoxManage extpack install --replace "${EXTENSION_PACK}"

# --- Étape 5: Installation de VMware Workstation ---

echo -e "${JAUNE}5. Installation de VMware Workstation Pro...${FIN}"

echo "Téléchargement de VMware Workstation (${FICHIER_VMWARE})..."
wget --output-document="${FICHIER_VMWARE}" "${URL_VMWARE}"
chmod +x "${FICHIER_VMWARE}"

echo "Lancement de l'installation de VMware (interface graphique)..."
# L'installation se fait en mode graphique et nécessite une interaction utilisateur
./"${FICHIER_VMWARE}"

# --- Étape 6: Configuration des Utilisateurs (Cruciale) ---

echo -e "${JAUNE}6. Ajout de l'utilisateur ${UTILISATEUR_REEL} aux groupes nécessaires...${FIN}"

# Groupes pour VirtualBox et KVM/libvirt
GROUPES_VIRT=("vboxusers" "kvm" "libvirt")

for GROUPE in "${GROUPES_VIRT[@]}"; do
    if getent group "$GROUPE" >/dev/null; then
        echo "Ajout à $GROUPE..."
        # Utilisation de -aG pour ajouter l'utilisateur aux groupes sans écraser les existants
        usermod -aG "$GROUPE" "${UTILISATEUR_REEL}"
    else
        echo -e "${JAUNE}AVERTISSEMENT : Le groupe '$GROUPE' n'existe pas. Ignoré.${FIN}"
    fi
done

# Les groupes 'disk', 'libvirt-qemu' et 'libvirt-dnsmasq' sont omis (sécurité/non nécessaires).

# --- Étape 7: Nettoyage et Finalisation ---

echo -e "${JAUNE}7. Nettoyage (suppression des fichiers temporaires)...${FIN}"
rm -f "${EXTENSION_PACK}" "${FICHIER_VMWARE}"

echo "Suppression du paquet kdeconnect (si présent)..."
apt remove kdeconnect -y || echo "kdeconnect n'était pas installé ou la suppression a échoué (ignoré)."
apt autoremove -y

echo -e "${VERT}*** Installation de la Suite SRV terminée ! ***${FIN}"
echo ""
echo -e "N'oubliez pas de vous ${ROUGE}déconnecter et reconnecter${VERT} pour que les changements de groupes (vboxusers, kvm, libvirt) prennent effet.${FIN}"
