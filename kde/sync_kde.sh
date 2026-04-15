#!/bin/bash

# Applies the portable coding-relevant KDE settings: keybinds, keyboard layout,
# virtual desktops, and tiling. Deliberately does NOT touch panel aesthetics,
# wallpapers, or applet layout — those are per-machine concerns.

set -euo pipefail

if command -v kwriteconfig6 >/dev/null; then
    KWRITE=kwriteconfig6
elif command -v kwriteconfig5 >/dev/null; then
    KWRITE=kwriteconfig5
else
    echo "No kwriteconfig found; skipping KDE sync." >&2
    exit 0
fi

QDBUS=$(command -v qdbus6 || command -v qdbus || true)

echo "Applying portable KDE settings with $KWRITE..."

# --- Global shortcuts ---
# Window management
"$KWRITE" --file kglobalshortcutsrc --group kwin --key "Window Close"    "Alt+F4,Alt+F4,Close Window"
"$KWRITE" --file kglobalshortcutsrc --group kwin --key "Window Maximize" "Meta+PgUp,Meta+PgUp,Maximize Window"
"$KWRITE" --file kglobalshortcutsrc --group kwin --key "Window Minimize" "Meta+PgDn,Meta+PgDn,Minimize Window"
"$KWRITE" --file kglobalshortcutsrc --group kwin --key "Overview"        "Meta+Tab,Meta+Tab,Toggle Overview"

# Audio
"$KWRITE" --file kglobalshortcutsrc --group kmix --key "mute"            "Volume Mute,Volume Mute,Mute"
"$KWRITE" --file kglobalshortcutsrc --group kmix --key "decrease_volume" "Volume Down,Volume Down,Decrease Volume"
"$KWRITE" --file kglobalshortcutsrc --group kmix --key "increase_volume" "Volume Up,Volume Up,Increase Volume"

# Session
"$KWRITE" --file kglobalshortcutsrc --group ksmserver --key "Lock Session" "Meta+L\tScreensaver,Meta+L\tScreensaver,Lock Session"

# --- Virtual desktops + tiling ---
"$KWRITE" --file kwinrc --group Desktops        --key "Number" 2
"$KWRITE" --file kwinrc --group Desktops        --key "Rows"   1
"$KWRITE" --file kwinrc --group Effect-overview --key "BorderActivate" 3
"$KWRITE" --file kwinrc --group "Tiling" --key "padding" 4
"$KWRITE" --file kwinrc --group "Tiling" --key "tiles" '{"layoutDirection":"horizontal","tiles":[{"width":0.25},{"width":0.5},{"width":0.25}]}'

# --- Keyboard layout (standardized across machines) ---
"$KWRITE" --file kxkbrc --group Layout --key "LayoutList"  "us"
"$KWRITE" --file kxkbrc --group Layout --key "VariantList" "altgr-intl"
"$KWRITE" --file kxkbrc --group Layout --key "Options"     "terminate:ctrl_alt_bksp"

# Live-reload keyboard layout if qdbus is available
if [ -n "$QDBUS" ]; then
    "$QDBUS" org.kde.keyboard /Layouts org.kde.KeyboardLayouts.reconfigure 2>/dev/null || true
fi

echo "KDE settings applied. Log out and back in for any shortcut changes to register."
