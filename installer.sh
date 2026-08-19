#!/bin/bash

# YouTube Downloader CLI - Automated Installer
#
# Quick install:
# mkdir -p ~/scripts && cd ~/scripts && \
# curl -fsSL "https://raw.githubusercontent.com/mmarkus13/yt-dlc/main/installer.sh" \
#   -o installer.sh && \
# chmod +x installer.sh && \
# ./installer.sh

set -euo pipefail

SCRIPT_DIR="$HOME/scripts"
REPO_RAW="https://raw.githubusercontent.com/mmarkus13/yt-dlc/main"

echo "🎵 YouTube Downloader CLI Installer"
echo "==================================="

# ------------------------------------------------------------
# Shell configuration
# ------------------------------------------------------------

case "${SHELL##*/}" in
    zsh)
        SHELL_RC="$HOME/.zshrc"
        ;;
    *)
        SHELL_RC="$HOME/.bashrc"
        ;;
esac

add_to_path() {
    local line='export PATH="$HOME/scripts:$PATH"'

    if [[ ! -f "$SHELL_RC" ]]; then
        touch "$SHELL_RC"
    fi

    if ! grep -Fqx "$line" "$SHELL_RC" 2>/dev/null; then
        echo "$line" >> "$SHELL_RC"
        echo "✓ Added ~/scripts to $SHELL_RC"
    else
        echo "✓ ~/scripts already configured in $SHELL_RC"
    fi

    export PATH="$HOME/scripts:$PATH"
}

add_deno_to_path() {
    local deno_line='export DENO_INSTALL="$HOME/.deno"'
    local path_line='export PATH="$DENO_INSTALL/bin:$PATH"'

    if ! grep -Fqx "$deno_line" "$SHELL_RC" 2>/dev/null; then
        echo "$deno_line" >> "$SHELL_RC"
    fi

    if ! grep -Fqx "$path_line" "$SHELL_RC" 2>/dev/null; then
        echo "$path_line" >> "$SHELL_RC"
    fi

    export DENO_INSTALL="$HOME/.deno"
    export PATH="$DENO_INSTALL/bin:$PATH"
}

# ------------------------------------------------------------
# Step 1: Create scripts directory
# ------------------------------------------------------------

echo "[1/6] Creating $SCRIPT_DIR..."
mkdir -p "$SCRIPT_DIR"

# ------------------------------------------------------------
# Step 2: Configure PATH
# ------------------------------------------------------------

echo "[2/6] Configuring PATH..."
add_to_path

# ------------------------------------------------------------
# Step 3: Install Deno
# ------------------------------------------------------------

echo "[3/6] Checking Deno..."

if command -v deno >/dev/null 2>&1; then
    echo "✓ Deno already installed: $(deno --version | head -n1)"
else
    echo "Installing Deno..."

    curl -fsSL "https://deno.land/install.sh" | sh

    add_deno_to_path

    if ! command -v deno >/dev/null 2>&1; then
        echo "Error: Deno installation completed but 'deno' is not available." >&2
        echo "Try opening a new shell and running: deno --version" >&2
        exit 1
    fi

    echo "✓ Deno installed: $(deno --version | head -n1)"
fi

# Make sure Deno's path is available even if it was installed previously.
if [[ -x "$HOME/.deno/bin/deno" ]]; then
    export DENO_INSTALL="$HOME/.deno"
    export PATH="$DENO_INSTALL/bin:$PATH"
fi

# ------------------------------------------------------------
# Step 4: Install yt-dlp
# ------------------------------------------------------------

echo "[4/6] Installing yt-dlp..."

curl -fsSL \
    "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp" \
    -o "$SCRIPT_DIR/yt-dlp"

chmod +x "$SCRIPT_DIR/yt-dlp"

echo "✓ yt-dlp installed: $("$SCRIPT_DIR/yt-dlp" --version)"

# ------------------------------------------------------------
# Step 5: Check / install FFmpeg
# ------------------------------------------------------------

echo "[5/6] Checking FFmpeg..."

if command -v ffmpeg >/dev/null 2>&1; then
    echo "✓ FFmpeg already installed: $(ffmpeg -version | head -n1)"
else
    echo "⚠ FFmpeg is not installed."
    echo ""

    read -r -p "Would you like the installer to install FFmpeg? [Y/n] " ANSWER
    ANSWER="${ANSWER:-Y}"

    if [[ "$ANSWER" =~ ^[Yy]$ ]]; then

        if [[ -f /etc/os-release ]]; then
            . /etc/os-release
        fi

        if [[ "${ID:-}" == "steamos" ]]; then

            echo ""
            echo "SteamOS uses a read-only system filesystem by default."
            echo "FFmpeg will be installed using the SteamOS package manager."
            echo "The read-only filesystem will be restored afterwards."
            echo ""

            if ! command -v steamos-readonly >/dev/null 2>&1; then
                echo "Error: steamos-readonly was not found." >&2
                echo "Install FFmpeg manually according to your SteamOS version." >&2
                exit 1
            fi

            sudo steamos-readonly disable

            restore_readonly() {
                sudo steamos-readonly enable || true
            }

            trap restore_readonly EXIT

            sudo pacman -S --needed ffmpeg

            sudo steamos-readonly enable
            trap - EXIT

        elif command -v apt-get >/dev/null 2>&1; then

            sudo apt-get update
            sudo apt-get install -y ffmpeg

        elif command -v brew >/dev/null 2>&1; then

            brew install ffmpeg

        elif command -v pacman >/dev/null 2>&1; then

            sudo pacman -S --needed ffmpeg

        else

            echo "Could not determine a supported package manager." >&2
            echo "Please install FFmpeg manually and run:" >&2
            echo "  ffmpeg -version" >&2
            exit 1

        fi

        if ! command -v ffmpeg >/dev/null 2>&1; then
            echo "Error: FFmpeg installation could not be verified." >&2
            exit 1
        fi

        echo "✓ FFmpeg installed: $(ffmpeg -version | head -n1)"

    else
        echo "⚠ FFmpeg installation skipped."
        echo "Video merging and MP3 extraction may not work correctly."
    fi
fi

# ------------------------------------------------------------
# Step 6: Install wrapper scripts
# ------------------------------------------------------------

echo "[6/6] Installing wrapper scripts..."

curl -fsSL \
    "$REPO_RAW/yt" \
    -o "$SCRIPT_DIR/yt"

curl -fsSL \
    "$REPO_RAW/ytmp3" \
    -o "$SCRIPT_DIR/ytmp3"

chmod +x \
    "$SCRIPT_DIR/yt" \
    "$SCRIPT_DIR/ytmp3"

echo "✓ Installed:"
echo "  $SCRIPT_DIR/yt"
echo "  $SCRIPT_DIR/ytmp3"

# ------------------------------------------------------------
# Final verification
# ------------------------------------------------------------

echo ""
echo "🎉 Installation complete!"
echo ""

echo "Installed versions:"
echo "  yt-dlp: $(("$SCRIPT_DIR/yt-dlp") --version)"
echo "  Deno:   $(deno --version | head -n1)"

if command -v ffmpeg >/dev/null 2>&1; then
    echo "  FFmpeg: $(ffmpeg -version | head -n1)"
else
    echo "  FFmpeg: not installed"
fi

echo ""
echo "The installer configured:"
echo "  $SHELL_RC"
echo ""

echo "Your current shell may need to reload the configuration:"
echo "  source \"$SHELL_RC\""
echo ""

echo "Then test with:"
echo "  yt https://www.youtube.com/watch?v=dQw4w9WgXcQ"
echo "  ytmp3 https://www.youtube.com/watch?v=BaW_jOozKJk"
echo ""

echo "See README.md for advanced options and troubleshooting."
