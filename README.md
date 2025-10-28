# 🚀 `srv` Suite Logicielle

## Installation Automatisée de la Suite "Stream Record Virtualization" (SRV)

-----

### 🇫🇷 Description du Projet

Ce projet est une collection de scripts Bash conçus pour automatiser l'installation complète d'une suite logicielle dédiée à la **Virtualisation, l'Enregistrement (Record) et la Diffusion (Stream)** sur les distributions basées sur Debian/Ubuntu.

Surnommée la suite **SRV**, elle installe tous les outils nécessaires à la création de contenu vidéo, de la capture d'écran au montage, en passant par la gestion de machines virtuelles.

**Compatibilité :**

  * **Linux Mint 21.x** (Cinnamon, Mate, Xfce)
  * **Ubuntu 22.04.x**

### 🇬🇧 Project Description

This project is a collection of Bash scripts designed to automate the complete installation of a software suite dedicated to **Virtualization, Recording, and Streaming** on Debian/Ubuntu-based distributions.

Dubbed the **SRV** suite, it installs all the necessary tools for video content creation, from screen capture to editing, including virtual machine management.

-----

### 📦 Logiciels Inclus

Le script installe automatiquement un large éventail de logiciels de pointe pour la création de contenu :

| Catégorie | Logiciels Installés | Description |
| :--- | :--- | :--- |
| **Virtualisation** | **Machines, KVM/Virtmanager, Quickemu, Quickgui, VirtualBox, VMware** | Suite complète pour créer, gérer et utiliser des machines virtuelles. |
| **Enregistrement/Streaming** | **Simple Screen Recorder (SSR), Open Broadcaster Software (OBS)** | Outils de capture d'écran légers et professionnels, et solution complète de diffusion en direct. |
| **Audio/Vidéo Édition** | **Audacity, Kdenlive** | Logiciel de retouche audio et éditeur de montage vidéo non linéaire puissant. |
| **Utilitaires Système** | **Diodon, Htop, Nmon, Neofetch, Zram** | Gestionnaire de presse-papiers, outils de surveillance des ressources (`htop`, `nmon`), information système (`neofetch`) et optimisation de la RAM (`zram`). |
| **Esthétique** | **Arc Theme, Papirus Icon Theme** | Thèmes de fenêtres et d'icônes pour une interface utilisateur moderne et cohérente. |

-----

### 🛠️ Installation et Différences entre les Scripts

Deux scripts sont fournis, la seule différence étant l'outil VMware installé :

| Script | Outil VMware Installé | Version Installée | Instructions |
| :--- | :--- | :--- | :--- |
| **`srv.sh`** | **VMware Player** | `VMware-Player-Full-16.2.4-20089737.x86_64.bundle` | 1. `chmod +x srv.sh` <br> 2. `sudo ./srv.sh` |
| **`srv2.sh`** | **VMware Workstation** | `VMware-Workstation-Full-16.2.4-20089737.x86_64.bundle` | 1. `chmod +x srv2.sh` <br> 2. `sudo ./srv2.sh` |

**REMARQUE / REMARK :**

  * **`srv.sh`** installe **VMware Player**, qui est gratuit pour un usage personnel.
  * **`srv2.sh`** installe **VMware Workstation**, qui nécessite une licence (ou peut être utilisé en période d'essai).

-----

### 📺 Démonstration

Regardez la vidéo ci-dessous pour voir l'installation automatique et la vérification de tous les logiciels composant la suite SRV :

| Vidéo | Chaîne | Lien |
| :--- | :--- | :--- |
| **SRV script (Stream Record Virtualisation)** | Blabla Linux | [Regarder la Démonstration](http://www.youtube.com/watch?v=UW3vA8QjONU) |

-----

### 📝 Licence

Ce projet est sous licence **[À compléter - Ex: MIT, GPL, etc.]**.
http://googleusercontent.com/youtube_content/8
