#!/bin/bash

set -euo pipefail

DOTFILES_DIR="$HOME/dotfiles"
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
BACKUPS_MADE=()

echo "--- Starting Dotfiles Installation ---"

# Restore backups if anything fails partway through
rollback() {
    local exit_code=$?
    if [ ${#BACKUPS_MADE[@]} -gt 0 ]; then
        echo "Install failed; restoring backups..."
        for entry in "${BACKUPS_MADE[@]}"; do
            local target="${entry%%::*}"
            local backup="${entry##*::}"
            [ -L "$target" ] && rm "$target"
            mv "$backup" "$target" 2>/dev/null || true
        done
    fi
    exit "$exit_code"
}
trap rollback ERR

# --- 1. Pull latest from git (only if working tree clean) ---
if [ -d "$DOTFILES_DIR/.git" ]; then
    if git -C "$DOTFILES_DIR" diff-index --quiet HEAD --; then
        echo "Pulling latest from remote..."
        git -C "$DOTFILES_DIR" pull --ff-only || echo "Pull failed, continuing with local state."
    else
        echo "Local changes present in $DOTFILES_DIR; skipping git pull."
    fi
fi

# --- 2. System dependencies (Arch Linux) ---
if ! command -v pacman >/dev/null; then
    echo "pacman not found — this script currently only supports Arch Linux." >&2
    exit 1
fi

echo "Refreshing package database..."
sudo pacman -Sy --noconfirm

REQUIRED_PACKAGES=(neovim kitty ripgrep fd fzf nodejs npm gcc make unzip curl git)
for pkg in "${REQUIRED_PACKAGES[@]}"; do
    if ! pacman -Qi "$pkg" >/dev/null 2>&1; then
        echo "Installing $pkg..."
        sudo pacman -S --noconfirm "$pkg"
    fi
done

# Font package is best-effort; fall back to manual download below.
if ! pacman -Qi ttf-jetbrains-mono-nerd >/dev/null 2>&1; then
    sudo pacman -S --noconfirm ttf-jetbrains-mono-nerd || true
fi

# --- 3. JetBrainsMono Nerd Font (manual fallback) ---
font_installed() {
    fc-list | grep -qiE "jetbrainsmono.*nerd" \
        || ls "$HOME/.local/share/fonts"/JetBrainsMono*NerdFont* >/dev/null 2>&1
}
if ! font_installed; then
    echo "JetBrainsMono Nerd Font not found. Installing manually..."
    mkdir -p "$HOME/.local/share/fonts"
    tmp_zip=$(mktemp --suffix=.zip)
    curl -fLo "$tmp_zip" https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
    unzip -o "$tmp_zip" -d "$HOME/.local/share/fonts" >/dev/null
    rm "$tmp_zip"
    fc-cache -f "$HOME/.local/share/fonts"
fi

# --- 4. Symlink helper ---
mkdir -p "$BACKUP_DIR"
link_file() {
    local source_file=$1
    local target_file=$2

    if [ -L "$target_file" ]; then
        rm "$target_file"
    elif [ -e "$target_file" ]; then
        local rel="${target_file#$HOME/}"
        local backup_path="$BACKUP_DIR/$rel"
        mkdir -p "$(dirname "$backup_path")"
        echo "Backing up $target_file -> $backup_path"
        mv "$target_file" "$backup_path"
        BACKUPS_MADE+=("$target_file::$backup_path")
    fi

    mkdir -p "$(dirname "$target_file")"
    ln -s "$source_file" "$target_file"
    echo "Linked $target_file -> $source_file"
}

# --- 5. Symlink app configs ---
[ -d "$DOTFILES_DIR/kitty/.config/kitty" ] && link_file "$DOTFILES_DIR/kitty/.config/kitty" "$HOME/.config/kitty"
[ -f "$DOTFILES_DIR/kitty/.local/share/applications/kitty.desktop" ] && \
    link_file "$DOTFILES_DIR/kitty/.local/share/applications/kitty.desktop" "$HOME/.local/share/applications/kitty.desktop"
[ -d "$DOTFILES_DIR/nvim/.config/nvim" ]   && link_file "$DOTFILES_DIR/nvim/.config/nvim"   "$HOME/.config/nvim"

# Custom XKB variant (Swedish letters on AltGr over US layout)
[ -f "$DOTFILES_DIR/kde/xkb/symbols/custom" ] && \
    link_file "$DOTFILES_DIR/kde/xkb/symbols/custom" "$HOME/.config/xkb/symbols/custom"

# Plasma session env var so KWin picks up ~/.config/xkb
[ -f "$DOTFILES_DIR/kde/plasma-workspace/env/00-xkb.sh" ] && \
    link_file "$DOTFILES_DIR/kde/plasma-workspace/env/00-xkb.sh" "$HOME/.config/plasma-workspace/env/00-xkb.sh"

# --- 6. Pre-install Neovim plugins (headless) ---
if command -v nvim >/dev/null; then
    echo "Syncing Neovim plugins..."
    nvim --headless "+Lazy! restore" +qa 2>/dev/null || echo "Nvim plugin install skipped (open nvim to finish setup)."
fi

# --- 7. KDE keybinds / layout (only if running KDE) ---
if [[ "${XDG_CURRENT_DESKTOP:-}" == *KDE* ]] && [ -f "$DOTFILES_DIR/kde/sync_kde.sh" ]; then
    chmod +x "$DOTFILES_DIR/kde/sync_kde.sh"
    "$DOTFILES_DIR/kde/sync_kde.sh"
else
    echo "Not a KDE session, skipping KDE keybind sync."
fi

# Backup dir is empty if nothing was backed up; remove it to keep $HOME tidy.
rmdir "$BACKUP_DIR" 2>/dev/null || true

trap - ERR
echo ""
echo "--- Dotfiles installed successfully! ---"
echo "Reboot the system for KDE keybinds, keyboard layout, and fonts to fully apply."
