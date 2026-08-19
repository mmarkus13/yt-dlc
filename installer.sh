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

echo "🎵 YouTube Downloader CLI Installer"
echo "==================================="

# --------------------------------------------------
# Step 1: Create scripts directory
# --------------------------------------------------

echo "[1/5] Creating $SCRIPT_DIR..."

mkdir -p "$SCRIPT_DIR"

# --------------------------------------------------
# Step 2: Install Deno
# --------------------------------------------------

echo "[2/5] Checking Deno..."

if command -v deno >/dev/null 2>&1; then

    echo "✓ Deno already installed: $(deno --version | head -n1)"

else

    echo "Installing Deno..."

    curl -fsSL https://deno.land/install.sh | sh

    export DENO_INSTALL="$HOME/.deno"
    export PATH="$DENO_INSTALL/bin:$PATH"

    # Add Deno configuration to .bashrc if not already present.
    if ! grep -Fqx 'export DENO_INSTALL="$HOME/.deno"' "$BASHRC" 2>/dev/null; then
        echo 'export DENO_INSTALL="$HOME/.deno"' >> "$BASHRC"
    fi

    if ! grep -Fqx 'export PATH="$DENO_INSTALL/bin:$PATH"' "$BASHRC" 2>/dev/null; then
        echo 'export PATH="$DENO_INSTALL/bin:$PATH"' >> "$BASHRC"
    fi

    echo "✓ Deno installed: $(deno --version | head -n1)"

fi

# --------------------------------------------------
# Step 3: Install yt-dlp
# --------------------------------------------------

echo "[3/5] Installing yt-dlp..."

YTDL="$SCRIPT_DIR/yt-dlp"

if [[ -x "$YTDL" ]]; then

    echo "✓ yt-dlp already installed: $("$YTDL" --version)"

else

    curl -fsSL \
        "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp" \
        -o "$YTDL"

    chmod +x "$YTDL"

    echo "✓ yt-dlp installed: $("$YTDL" --version)"

fi

# --------------------------------------------------
# Step 4: Create wrapper scripts
# --------------------------------------------------

echo "[4/5] Installing wrapper scripts..."

curl -fsSL \
  "https://raw.githubusercontent.com/mmarkus13/yt-dlc/main/yt" \
  -o "$SCRIPT_DIR/yt"

curl -fsSL \
  "https://raw.githubusercontent.com/mmarkus13/yt-dlc/main/ytmp3" \
  -o "$SCRIPT_DIR/ytmp3"

chmod +x "$SCRIPT_DIR/yt" "$SCRIPT_DIR/ytmp3"

echo "✓ Wrapper scripts installed"

# --------------------------------------------------
# Step 5: Configure PATH
# --------------------------------------------------

echo "[5/5] Configuring PATH..."

if grep -Fqx 'export PATH="$HOME/scripts:$PATH"' "$BASHRC" 2>/dev/null; then

    echo "✓ ~/scripts is already in PATH"

else

    echo 'export PATH="$HOME/scripts:$PATH"' >> "$BASHRC"

    echo "✓ Added ~/scripts to PATH"

fi

# Make ~/scripts available to this installer process.
export PATH="$HOME/scripts:$PATH"

echo ""
echo "🎉 Installation complete!"
echo ""
echo "Installed:"
echo "  yt-dlp: $("$YTDL" --version)"
echo "  Deno:   $(deno --version | head -n1)"
echo ""
echo "Activate the new PATH in your current shell:"
echo ""
echo "  source ~/.bashrc"
echo ""
echo "Then test with:"
echo ""
echo "  yt https://www.youtube.com/watch?v=dQw4w9WgXcQ"
echo "  ytmp3 https://www.youtube.com/watch?v=BaW_jOozKJk"
echo ""
echo "See README.md for advanced options and troubleshooting."
