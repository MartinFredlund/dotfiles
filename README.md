# Dotfiles

My personal configuration files for KDE Plasma, Kitty, and Neovim.

## Structure

- **kde/**: KDE Plasma configurations (shortcuts, window manager, and desktop applets).
- **kitty/**: Kitty terminal emulator configuration and themes.
- **nvim/**: Neovim configuration based on Kickstart.nvim.

## Installation

The repository includes an `install.sh` script that automates the process of backing up existing configurations and symlinking the files from this directory to `~/.config`.

```bash
cd ~/dotfiles
./install.sh
```

### What it does:
1. Creates a timestamped backup of any existing non-symlinked configs in `~/.dotfiles_backup_YYYYMMDD_HHMMSS`.
2. Removes existing symlinks to prevent conflicts.
3. Symlinks the following:
   - `kde/.config/*` -> `~/.config/`
   - `kitty/.config/kitty` -> `~/.config/kitty`
   - `nvim/.config/nvim` -> `~/.config/nvim`

## Syncing Changes

### Push Changes (Local to Remote)
Since the files in `~/.config` are symlinks, any changes made within the applications are reflected immediately in this repository.

1. Review changes: `git status`
2. Stage and commit: `git add . && git commit -m "Update configs"`
3. Push to your remote: `git push`

### Pull Changes (Remote to Local)
To update your local configuration from the remote repository:

1. Pull latest changes: `git pull`
2. Re-run the installation script if new files were added: `./install.sh`

---
Note: For KDE changes to fully apply after a fresh sync, it is recommended to log out and back in.
