#!/bin/bash

set -e

setup_flatpak() {
    echo "==> Setting up Flatpak with Flathub..."
    
    # Remove Fedora remote, add Flathub
    sudo flatpak remote-delete fedora --force 2>/dev/null || true
    sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    
    echo "==> Installing Flatpak apps..."
    sudo flatpak install -y flathub it.mijorus.gearlever
}

setup_multimedia() {
    echo "==> Installing multimedia codecs and drivers..."
    
    # Basic drivers and Vulkan support
    sudo dnf install -y mesa-dri-drivers mesa-vulkan-drivers vulkan-loader mesa-libGLU
    
    # Replace neutered ffmpeg with the real one
    sudo dnf swap -y ffmpeg-free ffmpeg --allowerasing
    
    # Install GStreamer plugins
    sudo dnf install -y gstreamer1-plugins-{bad-\*,good-\*,base} \
      gstreamer1-plugin-openh264 gstreamer1-libav lame\* \
      --exclude=gstreamer1-plugins-bad-free-devel
    
    # Install multimedia groups
    sudo dnf group install -y multimedia sound-and-video
    
    # Install VA-API for hardware acceleration
    sudo dnf install -y ffmpeg-libs libva libva-utils
    
    # Install Cisco OpenH264 codec
    sudo dnf install -y openh264 gstreamer1-plugin-openh264 mozilla-openh264
}

setup_utilities() {
    echo "==> Installing compression utilities..."
    sudo dnf install -y p7zip p7zip-plugins unrar
    
    echo "==> Installing FUSE..."
    sudo dnf install -y fuse fuse-libs
}

setup_snapper() {
    echo "==> Setting up Snapper for system snapshots..."
    sudo dnf install -y snapper
    sudo systemctl enable --now snapper-timeline.timer
    sudo systemctl enable --now snapper-cleanup.timer
}

optimize_system() {
    echo "==> Optimizing system services..."
    sudo systemctl disable NetworkManager-wait-online.service
}