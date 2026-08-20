#!/bin/bash

# YouTube Downloader CLI - Automated Installer
#
# Usage:
# mkdir -p ~/scripts && cd ~/scripts && \
# curl -fsSL "https://raw.githubusercontent.com/mmarkus13/yt-dlc/main/installer.sh" \
#   -o installer.sh && \
# chmod +x installer.sh && \
# ./installer.sh

set -e

SCRIPT_DIR="$HOME/scripts"
BASHRC="$HOME/.bashrc"
REPO_RAW="https://raw.githubusercontent.com/mmarkus13/yt-dlc/main"

echo "🎵 YouTube Downloader CLI Installer"
echo "==================================="

# ------------------------------------------------------------
# Step 1: Create scripts directory
# ------------------------------------------------------------

echo "[1/6] Creating $SCRIPT_DIR..."

mkdir -p "$SCRIPT_DIR"

echo "✓ Scripts directory ready"

# ------------------------------------------------------------
# Step 2: Configure PATH
# ------------------------------------------------------------

echo "[2/6] Configuring PATH..."

if [[ -f "$BASHRC" ]] &&
   grep -Fqx 'export PATH="$HOME/scripts:$PATH"' "$BASHRC"; then

    echo "✓ PATH already configured"

else

    echo 'export PATH="$HOME/scripts:$PATH"' >> "$BASHRC"

    echo "✓ PATH configured"

fi

# Make it available immediately in this installer process.
export PATH="$HOME/scripts:$PATH"

# ------------------------------------------------------------
# Step 3: Install / configure Deno
# ------------------------------------------------------------

echo "[3/6] Checking Deno..."

if command -v deno >/dev/null 2>&1; then

    echo "✓ Deno already installed:"
    deno --version | head -n1

else

    echo "Installing Deno..."

    curl -fsSL https://deno.land/install.sh | sh

    export DENO_INSTALL="$HOME/.deno"
    export PATH="$DENO_INSTALL/bin:$PATH"

    if [[ -f "$BASHRC" ]] &&
       ! grep -Fqx 'export DENO_INSTALL="$HOME/.deno"' "$BASHRC"; then

        echo 'export DENO_INSTALL="$HOME/.deno"' >> "$BASHRC"

    fi

    if [[ -f "$BASHRC" ]] &&
       ! grep -Fqx 'export PATH="$DENO_INSTALL/bin:$PATH"' "$BASHRC"; then

        echo 'export PATH="$DENO_INSTALL/bin:$PATH"' >> "$BASHRC"

    fi

    echo "✓ Deno installed:"
    deno --version | head -n1

fi

# ------------------------------------------------------------
# Step 4: Install yt-dlp
# ------------------------------------------------------------

echo "[4/6] Installing yt-dlp..."

curl -fsSL \
    "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp" \
    -o "$SCRIPT_DIR/yt-dlp"

chmod +x "$SCRIPT_DIR/yt-dlp"

echo "✓ yt-dlp installed:"
"$SCRIPT_DIR/yt-dlp" --version

# ------------------------------------------------------------
# Step 5: Check / optionally install FFmpeg
# ------------------------------------------------------------

echo "[5/6] Checking FFmpeg..."

if command -v ffmpeg >/dev/null 2>&1; then

    echo "✓ FFmpeg already installed:"
    ffmpeg -version 2>&1 | head -n1

else

    echo ""
    echo "⚠️ FFmpeg was not found."
    echo ""
    echo "FFmpeg is required for:"
    echo "  • MP3 extraction"
    echo "  • Merging separate video/audio streams"
    echo "  • Various video/audio conversions"
    echo ""

    read -r -p "Would you like to install FFmpeg now? [Y/n] " INSTALL_FFMPEG

    INSTALL_FFMPEG="${INSTALL_FFMPEG:-Y}"

    if [[ "$INSTALL_FFMPEG" =~ ^[Yy]$ ]]; then

        if command -v apt-get >/dev/null 2>&1; then

            echo "Installing FFmpeg using apt..."

            sudo apt-get update
            sudo apt-get install -y ffmpeg

        elif command -v brew >/dev/null 2>&1; then

            echo "Installing FFmpeg using Homebrew..."

            brew install ffmpeg

        elif command -v pacman >/dev/null 2>&1; then

            echo "Installing FFmpeg using pacman..."

            sudo pacman -S --needed ffmpeg

        else

            echo ""
            echo "⚠️ No supported package manager was detected."
            echo "Please install FFmpeg manually."
            echo ""

        fi

        if command -v ffmpeg >/dev/null 2>&1; then

            echo "✓ FFmpeg installed:"
            ffmpeg -version 2>&1 | head -n1

        else

            echo "⚠️ FFmpeg is still not available."
            echo "You can install it manually later."

        fi

    else

        echo "⚠️ FFmpeg installation skipped."
        echo "You can install it manually later."

    fi

fi

# ------------------------------------------------------------
# Step 6: Download repository wrapper scripts
# ------------------------------------------------------------

echo "[6/6] Installing wrapper scripts..."

for SCRIPT in yt ytmp3 yt-dlp-wrapper; do

    echo "Downloading $SCRIPT..."

    curl -fsSL \
        "$REPO_RAW/$SCRIPT" \
        -o "$SCRIPT_DIR/$SCRIPT"

    chmod +x "$SCRIPT_DIR/$SCRIPT"

    echo "✓ Installed $SCRIPT"

done

# ------------------------------------------------------------
# Activate configuration
# ------------------------------------------------------------

echo ""
echo "Activating shell configuration..."

if [[ -f "$BASHRC" ]]; then

    # shellcheck disable=SC1090
    source "$BASHRC"

fi

export PATH="$HOME/scripts:$PATH"

echo "✓ Shell configuration loaded"

# ------------------------------------------------------------
# Installation complete
# ------------------------------------------------------------

echo ""
echo "🎉 Installation complete!"
echo ""
echo "Installed:"
echo "  yt                 → $SCRIPT_DIR/yt"
echo "  ytmp3              → $SCRIPT_DIR/ytmp3"
echo "  yt-dlp-wrapper     → $SCRIPT_DIR/yt-dlp-wrapper"
echo "  yt-dlp             → $SCRIPT_DIR/yt-dlp"

if command -v ffmpeg >/dev/null 2>&1; then
    echo "  ffmpeg             → $(command -v ffmpeg)"
else
    echo "  ffmpeg             → NOT INSTALLED"
fi

echo ""
echo "You can now run:"
echo ""
echo '  yt "https://youtu.be/VIDEO_ID"'
echo '  ytmp3 "https://youtu.be/MUSIC_ID"'
echo ""

echo "If the commands are not available in a newly opened shell, run:"
echo ""
echo "  source ~/.bashrc"
echo ""

echo "See README.md for advanced options and troubleshooting."
echo ""
