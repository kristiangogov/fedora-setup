#!/bin/bash
set -e

source ./modules/update.sh
source ./modules/essentials.sh
source ./modules/apps.sh
source ./modules/configure.sh
source ./modules/fonts.sh

main() {
    echo "===================================="
    echo "  Fedora 43 Post-Install Setup"
    echo "===================================="
    echo ""
    
    # System updates
    read -rp "Run system updates? [Y/n]: " answer
    if [[ ! "$answer" =~ ^[Nn]$ ]]; then
        update
    fi
    
    # Firmware updates
    read -rp "Check for firmware updates? [Y/n]: " answer
    if [[ ! "$answer" =~ ^[Nn]$ ]]; then
        update_firmware
    fi
    
    echo ""
    
    # Flatpak setup
    read -rp "Set up Flatpak with Flathub? [Y/n]: " answer
    if [[ ! "$answer" =~ ^[Nn]$ ]]; then
        setup_flatpak
    fi
    
    # Multimedia codecs
    read -rp "Install multimedia codecs and drivers? [Y/n]: " answer
    if [[ ! "$answer" =~ ^[Nn]$ ]]; then
        setup_multimedia
    fi
    
    # Utilities
    read -rp "Install compression utilities and FUSE? [Y/n]: " answer
    if [[ ! "$answer" =~ ^[Nn]$ ]]; then
        setup_utilities
    fi
    
    # Snapper
    read -rp "Set up Snapper for system snapshots? [Y/n]: " answer
    if [[ ! "$answer" =~ ^[Nn]$ ]]; then
        setup_snapper
    fi
    
    # System optimizations
    read -rp "Apply system optimizations? [Y/n]: " answer
    if [[ ! "$answer" =~ ^[Nn]$ ]]; then
        optimize_system
    fi
    
    echo ""
    echo "Application Installation:"
    
    read -rp "  Install VS Code? [Y/n]: " answer
    [[ ! "$answer" =~ ^[Nn]$ ]] && setup_vscode
    
    read -rp "  Install Brave Browser? [Y/n]: " answer
    [[ ! "$answer" =~ ^[Nn]$ ]] && setup_brave
    
    read -rp "  Install media apps (VLC, OBS)? [Y/n]: " answer
    [[ ! "$answer" =~ ^[Nn]$ ]] && setup_media_apps
    
    read -rp "  Install OnlyOffice? [Y/n]: " answer
    [[ ! "$answer" =~ ^[Nn]$ ]] && setup_productivity_apps
    
    read -rp "  Install Konsave? [Y/n]: " answer
    [[ ! "$answer" =~ ^[Nn]$ ]] && setup_konsave
    
    read -rp "  Install Zen Browser? [Y/n]: " answer
    [[ ! "$answer" =~ ^[Nn]$ ]] && setup_zen
    
    echo ""
    echo "Configuration:"
    
    read -rp "  Restore KDE settings (Konsave)? [Y/n]: " answer
    [[ ! "$answer" =~ ^[Nn]$ ]] && restore_kde_settings
    
    read -rp "  Configure Git? [Y/n]: " answer
    [[ ! "$answer" =~ ^[Nn]$ ]] && setup_git
    
    read -rp "  Set up SSH key for GitHub? [Y/n]: " answer
    [[ ! "$answer" =~ ^[Nn]$ ]] && setup_ssh
    
    read -rp "  Install Fonts? [Y/n]: " answer
    [[ ! "$answer" =~ ^[Nn]$ ]] && install_fonts
    
    echo ""
    echo "===================================="
    echo "  Setup Complete!"
    echo "===================================="
}

main