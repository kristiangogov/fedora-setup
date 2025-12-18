#!/bin/bash

set -e

setup_vscode() {
    echo "==> Installing Visual Studio Code..."
    
    # Import Microsoft GPG key
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    
    # Add VS Code repository
    sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
    
    # Install VS Code
    sudo dnf install -y code
}

setup_brave() {
    echo "==> Installing Brave Browser..."
    
    sudo dnf install dnf-plugins-core
    
    sudo dnf config-manager addrepo --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
    
    sudo dnf install brave-browser -y
}

setup_zen() {
    echo "==> Installing Zen Browser..."
    sudo flatpak install -y flathub io.github.zen_browser.zen
}

setup_media_apps() {
    echo "==> Installing media applications..."
    
    # Install VLC
    sudo dnf install -y vlc
    
    # Install OBS Studio via Flatpak
    sudo flatpak install -y flathub com.obsproject.Studio
}

setup_productivity_apps() {
    echo "==> Installing productivity applications..."
    
    # Install OnlyOffice via Flatpak
    sudo flatpak install -y flathub org.onlyoffice.desktopeditors
}

setup_konsave() {
    echo "==> Installing Konsave (KDE settings manager)..."
    
    # Ensure pip is available
    if ! command -v pip &>/dev/null; then
        sudo dnf install -y python3-pip
    fi
    
    # Install konsave for current user
    python3 -m pip install --user konsave
    
    # Add user pip bin to PATH if not already there
    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
        echo "Note: You may need to restart your shell or run 'source ~/.bashrc' to use konsave"
    fi
}