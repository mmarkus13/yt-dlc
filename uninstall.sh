#!/bin/bash

set -u

echo ""
echo "🎵 yt-dlc uninstall"
echo ""

FILES=(
    "$HOME/scripts/yt"
    "$HOME/scripts/ytmp3"
    "$HOME/scripts/yt-dlp-wrapper"
    "$HOME/scripts/uninstall.sh"
    "$HOME/.local/bin/yt-dlp"
)

DIRECTORIES=(
    "$HOME/.config/yt-dlc"
    "$HOME/.cache/yt-dlc"
    "${XDG_DATA_HOME:-$HOME/.local/share}/yt-dlc"
)


echo "The following yt-dlc files will be removed:"
echo ""

for file in "${FILES[@]}"; do
    if [[ -e "$file" ]]; then
        echo "  $file"
    fi
done

for directory in "${DIRECTORIES[@]}"; do
    if [[ -e "$directory" ]]; then
        echo "  $directory/"
    fi
done

echo ""
echo "Your downloaded videos and music will NOT be removed."
echo ""

read -r -p "Continue with uninstall? [y/N] " ANSWER

if [[ ! "$ANSWER" =~ ^[Yy]$ ]]; then
    echo ""
    echo "Uninstall cancelled."
    exit 0
fi

echo ""

# ------------------------------------------------------------
# Remove installed files
# ------------------------------------------------------------

for file in "${FILES[@]}"; do
    if [[ -e "$file" ]]; then
        rm -f -- "$file"
        echo "✓ Removed $file"
    fi
done

# ------------------------------------------------------------
# Remove configuration/cache
# ------------------------------------------------------------

for directory in "${DIRECTORIES[@]}"; do
    if [[ -e "$directory" ]]; then
        rm -rf -- "$directory"
        echo "✓ Removed $directory/"
    fi
done

echo ""
echo "✓ yt-dlc has been uninstalled."
echo ""
echo "Downloaded media was left untouched."
