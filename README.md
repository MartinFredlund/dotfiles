# Dotfiles

Personal configs for Kitty, Neovim, and the coding-relevant slice of KDE Plasma
(keybinds, keyboard layout, tiling). Aesthetic KDE settings (panels, wallpapers,
applets) are intentionally left per-machine.

## Structure

- **kitty/**: Kitty terminal config.
- **nvim/**: Neovim config (Kickstart-based).
- **kde/sync_kde.sh**: Writes portable KDE settings via `kwriteconfig6`/`kwriteconfig5`.

## Install / Sync

One command, safe to re-run:

```bash
cd ~/dotfiles && ./install.sh
```

The script:
1. `git pull --ff-only` (only if the working tree is clean).
2. Refreshes the pacman DB and installs required packages.
3. Installs the JetBrainsMono Nerd Font (repo, falling back to GitHub release).
4. Backs up any non-symlinked existing configs to `~/.dotfiles_backup_<timestamp>/`.
5. Symlinks `kitty` and `nvim` configs into `~/.config/`.
6. Headlessly syncs Neovim plugins (`nvim --headless +Lazy! sync +qa`).
7. If running under KDE, applies portable keybinds/layout/tiling.

If any step fails, previously-moved configs are restored from the backup dir.

## Pushing changes

Kitty and Neovim changes are live (symlinked). For KDE, edit `kde/sync_kde.sh`
directly — the script is the source of truth, not your live `~/.config/*rc`.

```bash
git add . && git commit -m "Update configs" && git push
```

## Notes

- Log out and back in after install for KDE keybinds and font changes to fully register.
- Arch Linux only (uses `pacman`).
