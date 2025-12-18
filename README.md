# Fedora Setup Scripts

Automated post-installation setup for Fedora 43 KDE Plasma.

## Quick Start

```bash
# Clone the repository
git clone https://github.com/kristiangogov/fedora-setup.git
cd fedora-setup

# Make the main script executable
chmod +x setup.sh

# Run the setup
./setup.sh
```

The script will prompt you for each step - just press Enter to accept (default is Yes) or type `n` to skip.

No git download:
```bash
curl -L https://codeload.github.com/kristiangogov/fedora-setup/tar.gz/main | tar -xz
```

## Structure

```
.
├── setup.sh              # Main orchestrator script
└── modules/
    ├── update.sh         # System and firmware updates
    ├── essentials.sh     # Flatpak, multimedia, utilities, Snapper
    ├── apps.sh           # Application installation
    ├── configure.sh      # Git, SSH, GitHub, Konsave
    └── fonts.sh          # Installs fonts from .zip files
```

## Requirements

- Fresh Fedora 43 installation (KDE Plasma spin recommended)
- Internet connection
- sudo privileges

## What Gets Installed

### System Essentials
- RPM Fusion (Free & Nonfree)
- Mesa drivers and Vulkan support
- ffmpeg (full version)
- GStreamer plugins
- VA-API hardware acceleration
- p7zip, unrar, FUSE
- Snapper (system snapshots)

### Applications
- Visual Studio Code
- Brave Browser
- Zen Browser
- VLC Media Player
- OBS Studio
- OnlyOffice
- Konsave (KDE settings manager)
- Gear Lever (Flatpak manager)

## Customization

Each module is independent and can be run separately. Edit `setup.sh` to comment out sections you don't need, or modify individual module files to add/remove packages.

## Backups

The script uses:
- **Konsave** for KDE settings backup/restore (requires a konsave profile export, obviously)
- **Snapper** for system snapshots (configure separately)

## Fonts

- Local set of font archives

## Notes

- The script is idempotent - safe to run multiple times
- Reboot prompts appear after updates when needed
- SSH keys are generated as ed25519 (modern standard)
- All installations use official repositories when possible

## License

MIT

## Contributing

Feel free to open issues or submit pull requests with improvements!