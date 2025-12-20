#!/bin/bash
set -e

personalize_vscode() {
    echo "NOTE: This script assumes your homedir backup preserves:
  - .vscode
  - .config/Code/User/settings.json
at their original paths."

    read -rp "Provide the path to your homedir backup: " files_dir

    if [[ ! -d "$files_dir" ]]; then
        echo "Directory does not exist."
        return 1
    fi

    src_settings="$files_dir/.config/Code/User/settings.json"
    src_folder="$files_dir/.vscode"

    local_settings="$HOME/.config/Code/User/settings.json"
    local_folder="$HOME"

    if [[ ! -f "$src_settings" ]]; then
        echo "settings.json not found in backup."
        return 1
    fi

    if [[ ! -d "$src_folder" ]]; then
        echo ".vscode directory not found in backup."
        return 1
    fi

    mkdir -p "$(dirname "$local_settings")"

    cp -r "$src_folder" "$local_folder"
    cp "$src_settings" "$local_settings"

    echo "Visual Studio Code personalized successfully!"
}