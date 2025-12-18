#!/bin/bash

set -e

install_fonts() {
    read -rp "Enter the directory containing font .zip files: " font_dir

    if [[ ! -d "$font_dir" ]]; then
        echo "Directory does not exist."
        return 1
    fi

    local_fonts="$HOME/.local/share/fonts"
    mkdir -p "$local_fonts"

    shopt -s nullglob
    for zip_file in "$font_dir"/*.zip; do
        echo "Installing fonts from: $zip_file"
        unzip -q -o "$zip_file" -d "$local_fonts"
    done

    fc-cache -fv "$local_fonts"

    echo "Fonts installed successfully!"
}
