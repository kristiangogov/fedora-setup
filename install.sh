#!/bin/bash
set -e

echo "Downloading Fedora setup scripts..."

TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

curl -fsSL https://github.com/kristiangogov/fedora-setup/archive/refs/heads/main.tar.gz -o setup.tar.gz

tar -xzf setup.tar.gz

cd dotfiles-main

chmod +x setup.sh

./setup.sh
