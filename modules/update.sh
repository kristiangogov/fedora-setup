#!/bin/bash

set -e

check_reboot() {
    if ! sudo needs-restarting -r &>/dev/null; then
        echo ""
        read -rp "Reboot required. Reboot now? [y/N]: " answer
        [[ "$answer" =~ ^[Yy]$ ]] && sudo reboot
    fi
}

update() {
    echo "==> Adding repositories..."
    
    # RPM Fusion Free
    if ! rpm -q rpmfusion-free-release &>/dev/null; then
        sudo dnf install -y \
        https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
    else
        echo "RPM Fusion Free already installed"
    fi
    
    # RPM Fusion Nonfree
    if ! rpm -q rpmfusion-nonfree-release &>/dev/null; then
        sudo dnf install -y \
        https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
    else
        echo "RPM Fusion Nonfree already installed"
    fi
    
    echo "==> Running system updates..."
    sudo dnf upgrade --refresh -y
    
    echo "==> Updates complete."
    
    # Check if reboot needed (install dnf-utils if missing)
    if ! command -v needs-restarting &>/dev/null; then
        sudo dnf install -y dnf-utils
    fi
    
    check_reboot
}

update_firmware() {
    echo "==> Checking for firmware updates..."
    
    if ! command -v fwupdmgr &>/dev/null; then
        echo "fwupdmgr not found, skipping firmware updates"
        return
    fi
    
    sudo fwupdmgr refresh --force
    
    # Check for updates (returns non-zero if none available)
    if sudo fwupdmgr get-updates 2>/dev/null; then
        echo ""
        read -rp "Firmware updates available. Install now? [y/N]: " answer
        if [[ "$answer" =~ ^[Yy]$ ]]; then
            sudo fwupdmgr update -y
            echo "==> Firmware updates complete."
            check_reboot
        else
            echo "Skipping firmware updates."
        fi
    else
        echo "No firmware updates available."
    fi
}