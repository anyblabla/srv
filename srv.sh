#!/bin/bash
#
# Autheur:
#   Amaury Libert <amaury-libert@hotmail.com> de Blabla Linux <https://blablalinux.be>
#
# Description:
#   Script d'installations logiciels pour Linux Mint 21 (Cinnamon/Mate/xfce) et Ubuntu 22.04 afin d'obtenir la suite logiciels SRV "Stream Record Virtualisation".
#
# Préambule Légal:
# 	Ce script est un logiciel libre.
# 	Vous pouvez le redistribuer et / ou le modifier selon les termes de la licence publique générale GNU telle que publiée par la Free Software Foundation; version 3.
#
# 	Ce script est distribué dans l'espoir qu'il sera utile, mais SANS AUCUNE GARANTIE; sans même la garantie implicite de QUALITÉ MARCHANDE ou d'ADÉQUATION À UN USAGE PARTICULIER.
# 	Voir la licence publique générale GNU pour plus de détails.
#
# 	Licence publique générale GNU : <https://www.gnu.org/licenses/gpl-3.0.txt>
#
#
# Effacement ecran
echo "Effacement écran..."
clear
#
#
# Rafraîchissement dépôts
echo "Rafraîchissement dépôts + mises à jour..."
apt update && apt upgrade -y
#
#
# Logiciels hors dépôts (installations)
echo "Clone du projet GitHub OBS Studio - Fully Loaded..."
git clone https://github.com/wimpysworld/obs-fully-loaded.git
#
echo "Ajouts du dépôt supplémentaire : flexiondotorg pour quickemu..."
apt-add-repository -y ppa:flexiondotorg/quickemu
#
echo "Ajouts du dépôt supplémentaire : yannick-mauray pour quickgui..."
add-apt-repository -y ppa:yannick-mauray/quickgui
#
echo "VirtualBox - Installer les paquets requis..."
apt install wget apt-transport-https gnupg2 ubuntu-keyring -y
#
echo "VirtualBox - Importer la clé GPG..." 
wget -O- https://www.virtualbox.org/download/oracle_vbox_2016.asc | gpg --dearmor | tee /usr/share/keyrings/virtualbox.gpg
#
echo "VirtualBox - Importer le dépôt VirtualBox..."
echo deb [arch=amd64 signed-by=/usr/share/keyrings/virtualbox.gpg] http://download.virtualbox.org/virtualbox/debian jammy contrib | tee /etc/apt/sources.list.d/virtualbox.list
#
echo "Téléchargement de VMware-Player-Full-16.2.3-19376536.x86_64.bundle + rendre éxécutable..."
wget https://www.dropbox.com/s/8tlc8k4k2bwcz1s/VMware-Player-Full-16.2.3-19376536.x86_64.bundle
chmod +x VMware-Player-Full-16.2.3-19376536.x86_64.bundle
#
echo "Rafraîchissement dépôts..."
apt update
#
echo "Installations de obs-studio, ffmpeg, quickemu, quickgui, virtualbox..."
cd obs-fully-loaded
./obs-install.sh
apt install -y ffmpeg quickemu quickgui virtualbox-6.1
#
echo "Téléchargement du pack d'extension USB..."
version=$(VBoxManage --version|cut -dr -f1|cut -d'_' -f1) && wget -c http://download.virtualbox.org/virtualbox/$version/Oracle_VM_VirtualBox_Extension_Pack-$version.vbox-extpack
#
echo "Installation du pack d'extension USB..."
echo "y" | VBoxManage extpack install --replace Oracle_VM_VirtualBox_Extension_Pack-$version.vbox-extpack
#
echo "Installation de VMware-Player-Full-16.2.1-18811642.x86_64.bundle..."
./VMware-Player-Full-16.2.3-19376536.x86_64.bundle
#
#
# Logiciels à partir des dépôts (installations)
echo "Installations de logiciels (et thème) à partir des dépôts : papirus-icon-theme, arc-theme, htop, nmon, neofetch, zram-tools, audacity, kdenlive, diodon, simplescreenrecorder, qemu, qemu-kvm, libvirt0, virt-manager, python3-guestfs, libguestfs-tools, ovmf, ssh-askpass, ssh-askpass-gnome, bridge-utils, gnome-boxes, openssh-server..."
apt install -y papirus-icon-theme arc-theme htop nmon neofetch zram-tools audacity kdenlive diodon simplescreenrecorder
apt install -y -o 'apt::install-recommends=true' \
  qemu qemu-kvm libvirt0 virt-manager python3-guestfs libguestfs-tools ovmf ssh-askpass ssh-askpass-gnome bridge-utils gnome-boxes openssh-server
#
#
echo "VirtualBox KVM ajouts groupes..."
usermod -G vboxusers -a $SUDO_USER
usermod -G disk -a $SUDO_USER
usermod -G kvm -a $SUDO_USER
usermod -G libvirt -a $SUDO_USER
usermod -G libvirt-qemu -a $SUDO_USER
usermod -G libvirt-dnsmasq -a $SUDO_USER
#
#
echo "Suppressions téléchargements..."
rm *.vbox-extpack *.bundle
#
echo "Nettoyage..."
apt autoremove
