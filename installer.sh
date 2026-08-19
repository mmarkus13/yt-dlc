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

# Step 1: Create scripts directory
echo "[1/5] Creating $SCRIPT_DIR..."
mkdir -p "$SCRIPT_DIR"

# Step 2: Install Deno
echo "[2/5] Installing Deno..."

if command -v deno >/dev/null 2>&1; then
    echo "✓ Deno already installed: $(deno --version | head -n1)"
else
    curl -fsSL https://deno.land/install.sh | sh

    export DENO_INSTALL="$HOME/.deno"
    export PATH="$DENO_INSTALL/bin:$PATH"

    echo "✓ Deno installed: $(deno --version | head -n1)"
fi

# Step 3: Install yt-dlp
echo "[3/5] Installing yt-dlp..."

curl -fsSL \
    "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp" \
    -o "$SCRIPT_DIR/yt-dlp"

chmod +x "$SCRIPT_DIR/yt-dlp"

echo "✓ yt-dlp installed: $("$SCRIPT_DIR/yt-dlp" --version)"

# Step 4: Create wrapper scripts
echo "[4/5] Creating wrapper scripts..."

cat > "$SCRIPT_DIR/yt" << 'EOF'
#!/bin/bash

YTDL="$HOME/scripts/yt-dlp"

if [[ ! -x "$YTDL" ]]; then
    echo "Error: yt-dlp not found at $YTDL" >&2
    exit 1
fi

if [[ -z "$1" ]]; then
    read -r -p "Enter YouTube URL: " URL
else
    URL="$1"
fi

if [[ -z "$URL" ]]; then
    echo "Error: No URL provided" >&2
    exit 1
fi

exec "$YTDL" \
    --js-runtimes deno \
    -S "res,ext:mp4,m4a" \
    --recode mp4 \
    "$URL"
EOF

cat > "$SCRIPT_DIR/ytmp3" << 'EOF'
#!/bin/bash

YTDL="$HOME/scripts/yt-dlp"

if [[ ! -x "$YTDL" ]]; then
    echo "Error: yt-dlp not found at $YTDL" >&2
    exit 1
fi

if [[ -z "$1" ]]; then
    read -r -p "Enter YouTube URL: " URL
else
    URL="$1"
fi

if [[ -z "$URL" ]]; then
    echo "Error: No URL provided" >&2
    exit 1
fi

exec "$YTDL" \
    --js-runtimes deno \
    --extract-audio \
    --audio-format mp3 \
    --audio-quality 0 \
    "$URL"
EOF

chmod +x "$SCRIPT_DIR/yt" "$SCRIPT_DIR/ytmp3"

echo "✓ Scripts created:"
echo "  $SCRIPT_DIR/yt"
echo "  $SCRIPT_DIR/ytmp3"

# Step 5: Configure PATH
echo "[5/5] Configuring PATH..."

if grep -Fqx 'export PATH="$HOME/scripts:$PATH"' "$BASHRC" 2>/dev/null; then
    echo "✓ ~/scripts is already in PATH"
else
    echo 'export PATH="$HOME/scripts:$PATH"' >> "$BASHRC"
    echo "✓ Added ~/scripts to PATH"
fi

# Make the new PATH available to this installer process
export PATH="$HOME/scripts:$PATH"

echo ""
echo "🎉 Installation complete!"
echo ""
echo "Installed:"
echo "  yt-dlp: $("$SCRIPT_DIR/yt-dlp" --version)"
echo "  Deno:   $(deno --version | head -n1)"
echo ""
echo "To activate the new PATH in your current shell, run:"
echo "  source ~/.bashrc"
echo ""
echo "Then test with:"
echo "  yt https://www.youtube.com/watch?v=dQw4w9WgXcQ"
echo "  ytmp3 https://www.youtube.com/watch?v=BaW_jOozKJk"
echo ""
echo "See README.md for advanced options and troubleshooting."
