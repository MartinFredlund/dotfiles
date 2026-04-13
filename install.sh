#!/bin/bash

# A simple script to backup existing configs and symlink the dotfiles.
DOTFILES_DIR="$HOME/dotfiles"
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

echo "Creating backup directory at $BACKUP_DIR"
mkdir -p "$BACKUP_DIR/.config"

link_file() {
    local source_file=$1
    local target_file=$2

    # Check if target exists and is NOT a symlink
    if [ -e "$target_file" ] && [ ! -L "$target_file" ]; then
        echo "Backing up $target_file to $BACKUP_DIR"
        mkdir -p "$(dirname "$BACKUP_DIR/${target_file#$HOME/}")"
        mv "$target_file" "$BACKUP_DIR/${target_file#$HOME/}"
    elif [ -L "$target_file" ]; then
        echo "Removing existing symlink $target_file"
        rm "$target_file"
    fi

    echo "Linking $target_file -> $source_file"
    mkdir -p "$(dirname "$target_file")"
    ln -s "$source_file" "$target_file"
}

# KDE configs
if [ -d "$DOTFILES_DIR/kde/.config" ]; then
    for f in "$DOTFILES_DIR/kde/.config/"*; do
        if [ -f "$f" ]; then
            filename=$(basename "$f")
            link_file "$f" "$HOME/.config/$filename"
        fi
    done
fi

# Kitty and Nvim (linking the whole directory)
if [ -d "$DOTFILES_DIR/kitty/.config/kitty" ]; then
    link_file "$DOTFILES_DIR/kitty/.config/kitty" "$HOME/.config/kitty"
fi

if [ -d "$DOTFILES_DIR/nvim/.config/nvim" ]; then
    link_file "$DOTFILES_DIR/nvim/.config/nvim" "$HOME/.config/nvim"
fi

echo ""
echo "Dotfiles installed successfully!"
echo "If you want to sync this on your other machine:"
echo "1. Push this git repository to a host (GitHub/GitLab)."
echo "2. Clone it to ~/dotfiles on the second machine."
echo "3. Run ~/dotfiles/install.sh"
