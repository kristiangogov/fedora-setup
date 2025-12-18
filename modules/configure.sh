#!/bin/bash

set -e

restore_kde_settings() {
    echo "==> Restoring KDE settings with Konsave..."
    
    # Check if konsave is installed
    if ! command -v konsave &>/dev/null; then
        echo "ERROR: Konsave is not installed or not in PATH"
        echo "Please install it first or add ~/.local/bin to your PATH"
        return 1
    fi
    
    # Prompt for profile location
    echo ""
    echo "Where is your Konsave profile?"
    echo "  1) Import from file"
    echo "  2) Already in ~/.config/konsave/profiles/"
    echo "  3) Skip"
    read -rp "Choose option [1/2/3]: " choice
    
    case $choice in
        1)
            read -rp "Enter path to Konsave profile file (.knsv): " profile_path
            if [[ -f "$profile_path" ]]; then
                konsave -i "$profile_path"
                echo "Profile imported successfully"
                
                # List available profiles
                echo ""
                echo "Available profiles:"
                konsave -l
                
                read -rp "Enter profile name to apply: " profile_name
                konsave -a "$profile_name"
                echo "Profile applied! You may need to log out and back in for all changes to take effect."
            else
                echo "ERROR: File not found: $profile_path"
                return 1
            fi
            ;;
        2)
            echo ""
            echo "Available profiles:"
            konsave -l
            echo ""
            read -rp "Enter profile name to apply: " profile_name
            konsave -a "$profile_name"
            echo "Profile applied! You may need to log out and back in for all changes to take effect."
            ;;
        3)
            echo "Skipping KDE settings restore"
            ;;
        *)
            echo "Invalid option"
            return 1
            ;;
    esac
}

setup_git() {
    echo "==> Configuring Git..."
    
    # Check if git is installed
    if ! command -v git &>/dev/null; then
        echo "Git not found, installing..."
        sudo dnf install -y git
    fi
    
    # Check if already configured
    if git config --global user.name &>/dev/null && git config --global user.email &>/dev/null; then
        current_name=$(git config --global user.name)
        current_email=$(git config --global user.email)
        echo ""
        echo "Git is already configured:"
        echo "  Name: $current_name"
        echo "  Email: $current_email"
        echo ""
        read -rp "Reconfigure? [y/N]: " answer
        if [[ ! "$answer" =~ ^[Yy]$ ]]; then
            echo "Keeping current Git configuration"
            return
        fi
    fi
    
    # Get user info
    echo ""
    read -rp "Enter your Git username: " git_name
    read -rp "Enter your Git email: " git_email
    
    # Configure git
    git config --global user.name "$git_name"
    git config --global user.email "$git_email"
    
    # Optional: Set default branch name to main
    read -rp "Set default branch name to 'main'? [Y/n]: " answer
    if [[ ! "$answer" =~ ^[Nn]$ ]]; then
        git config --global init.defaultBranch main
    fi
    
    echo ""
    echo "Git configured successfully:"
    echo "  Name: $(git config --global user.name)"
    echo "  Email: $(git config --global user.email)"
}

setup_ssh() {
    echo "==> Setting up SSH key..."
    
    ssh_dir="$HOME/.ssh"
    ssh_key="$ssh_dir/id_ed25519"
    
    # Check if SSH key already exists
    if [[ -f "$ssh_key" ]]; then
        echo ""
        echo "SSH key already exists at: $ssh_key"
        echo ""
        read -rp "Generate a new key? (will backup old key) [y/N]: " answer
        if [[ "$answer" =~ ^[Yy]$ ]]; then
            # Backup existing key
            timestamp=$(date +%Y%m%d_%H%M%S)
            mv "$ssh_key" "${ssh_key}.backup_${timestamp}"
            mv "${ssh_key}.pub" "${ssh_key}.pub.backup_${timestamp}"
            echo "Old key backed up with timestamp: $timestamp"
        else
            echo "Using existing SSH key"
            cat "${ssh_key}.pub"
            echo ""
            echo "Public key displayed above ^"
            setup_github_key
            return
        fi
    fi
    
    # Create .ssh directory if it doesn't exist
    mkdir -p "$ssh_dir"
    chmod 700 "$ssh_dir"
    
    # Get email for SSH key
    git_email=$(git config --global user.email 2>/dev/null)
    if [[ -z "$git_email" ]]; then
        read -rp "Enter email for SSH key: " git_email
    else
        echo "Using Git email: $git_email"
    fi
    
    # Generate SSH key
    echo ""
    echo "Generating SSH key..."
    ssh-keygen -t ed25519 -C "$git_email" -f "$ssh_key" -N ""
    
    # Start ssh-agent and add key
    eval "$(ssh-agent -s)"
    ssh-add "$ssh_key"
    
    echo ""
    echo "SSH key generated successfully!"
    echo ""
    echo "Your public key:"
    cat "${ssh_key}.pub"
    echo ""
    
    setup_github_key
}

setup_github_key() {
    echo "==> Adding SSH key to GitHub..."
    echo ""
    echo "Your public SSH key has been copied to clipboard (if xclip is available)"
    
    # Try to copy to clipboard
    if command -v xclip &>/dev/null; then
        cat "$HOME/.ssh/id_ed25519.pub" | xclip -selection clipboard
        echo "✓ Key copied to clipboard"
    elif command -v wl-copy &>/dev/null; then
        cat "$HOME/.ssh/id_ed25519.pub" | wl-copy
        echo "✓ Key copied to clipboard"
    else
        echo "Install xclip or wl-clipboard to auto-copy to clipboard"
    fi
    
    echo ""
    echo "Steps to add your SSH key to GitHub:"
    echo "  1. Go to: https://github.com/settings/ssh/new"
    echo "  2. Give it a title (e.g., 'Fedora 43 Laptop')"
    echo "  3. Paste your public key"
    echo "  4. Click 'Add SSH key'"
    echo ""
    
    read -rp "Press Enter once you've added the key to GitHub..."
    
    # Test SSH connection
    echo ""
    echo "Testing GitHub SSH connection..."
    if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
        echo "✓ GitHub SSH connection successful!"
    else
        echo "⚠ Could not verify GitHub connection. You may need to add the key manually."
        echo "Run 'ssh -T git@github.com' to test later."
    fi
}