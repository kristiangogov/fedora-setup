#!/bin/bash
set -e

source ./modules/update.sh
source ./modules/essentials.sh
source ./modules/apps.sh
source ./modules/configure.sh
source ./modules/fonts.sh

prompt() {
    local prompt="$1"
    local response
    read -rp "$prompt [Y/n]: " response
    case "${response,,}" in
        n|no) return 1 ;;
        *) return 0 ;;
    esac
}

setup_system() {
    prompt "Run system updates?" && update
    prompt "Check for firmware updates?" && update_firmware
}

setup_essentials() {
    prompt "Set up Flatpak with Flathub?" && setup_flatpak
    prompt "Install multimedia codecs and drivers?" && setup_multimedia
    prompt "Install compression utilities and FUSE?" && setup_utilities
    prompt "Set up Snapper for system snapshots?" && setup_snapper
    prompt "Apply system optimizations?" && optimize_system
}

install_applications() {
    echo ""
    echo "Application Installation:"
    
    prompt "  Install VS Code?" && setup_vscode
    prompt "  Install Brave Browser?" && setup_brave
    prompt "  Install media apps (VLC, OBS)?" && setup_media_apps
    prompt "  Install OnlyOffice?" && setup_productivity_apps
    prompt "  Install Konsave?" && setup_konsave
    prompt "  Install Zen Browser?" && setup_zen
}

configure_system() {
    echo ""
    echo "Configuration:"
    
    prompt "  Restore KDE settings (Konsave)?" && restore_kde_settings
    prompt "  Configure Git?" && setup_git
    prompt "  Set up SSH key for GitHub?" && setup_ssh
    prompt "  Install Fonts?" && install_fonts
}

main() {
    echo "===================================="
    echo "  Fedora 43 Post-Install Setup"
    echo "===================================="
    echo ""
    
    setup_system
    setup_essentials
    
    install_applications
    configure_system
    
    echo ""
    echo "===================================="
    echo "  Setup Complete!"
    echo "===================================="
}

main