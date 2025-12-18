#!/bin/bash
set -e

echo "Downloading Fedora setup scripts..."

curl -fsSL https://codeload.github.com/kristiangogov/fedora-setup/tar.gz/main -o setup.tar.gz

tar -xzf setup.tar.gz

cd fedora-setup-main

chmod +x setup.sh

./setup.sh
