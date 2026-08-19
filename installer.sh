#!/bin/bash
# YouTube Downloader CLI - Automated Installer
# Usage: mkdir -p ~/scripts && cd ~/scripts && wget -O installer.sh https://raw.githubusercontent.com/mmarkus13/yt-dlc/refs/heads/main/installer.sh && chmod +x installer.sh && ./installer.sh

set -e

SCRIPT_DIR="$HOME/scripts"
echo "🎵 YouTube Downloader CLI Installer"
echo "==================================="

# Step 0: Add ~/scripts to PATH if it isn't already there
if [[ ":$PATH:" != *":$HOME/scripts:"* ]]; then
    echo 'export PATH="$HOME/scripts:$PATH"' >> "$HOME/.bashrc"
fi
export PATH="$HOME/scripts:$PATH"

# Step 1: Create scripts directory
echo "[1/6] Creating $SCRIPT_DIR..."
mkdir -p "$SCRIPT_DIR"

# Step 2: Install Deno
echo "[2/6] Installing Deno..."
if command -v deno &> /dev/null; then
    echo "✓ Deno already installed: $(deno --version | head -n1)"
else
    curl -fsSL https://deno.land/x/install/install.sh | sh
    echo 'export DENO_INSTALL="$HOME/.deno"' >> ~/.bashrc
    echo 'export PATH="$DENO_INSTALL/bin:$PATH"' >> ~/.bashrc
    export DENO_INSTALL="$HOME/.deno"
    export PATH="$DENO_INSTALL/bin:$PATH"
    echo "✓ Deno installed. Run: source ~/.bashrc"
fi

# Step 3: Download yt-dlp
echo "[3/6] Downloading yt-dlp..."
wget -q https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -O "$SCRIPT_DIR/yt-dlp"
chmod +x "$SCRIPT_DIR/yt-dlp"
echo "✓ yt-dlp installed: $($SCRIPT_DIR/yt-dlp --version)"

# Step 4: Install Python dependencies
echo "[4/6] Installing yt-dlp-ejs..."
pip install -q yt-dlp-ejs
echo "✓ yt-dlp-ejs installed"

# Step 5: Create wrapper scripts
echo "[5/6] Creating wrapper scripts..."

cat > "$SCRIPT_DIR/yt" << 'EOF'
#!/bin/bash

YTDL="/home/$USER/scripts/yt-dlp"

if [[ ! -f "$YTDL" ]]; then
    echo "Error: yt-dlp not found at $YTDL" >&2
    exit 1
fi

if [ -z "$1" ]; then
    read -p "Enter YouTube URL: " URL
else
    URL="$1"
fi

if [ -z "$URL" ]; then
    echo "Error: No URL provided" >&2
    exit 1
fi

exec "$YTDL" \
    --js-runtimes deno \
    --extractor-args "youtube:player_client=web" \
    -S res,ext:mp4,m4a \
    --recode mp4 \
    --no-part \
    "$URL"
EOF

cat > "$SCRIPT_DIR/ytmp3" << 'EOF'
#!/bin/bash

YTDL="/home/$USER/scripts/yt-dlp"

if [[ ! -f "$YTDL" ]]; then
    echo "Error: yt-dlp not found at $YTDL" >&2
    exit 1
fi

if [ -z "$1" ]; then
    read -p "Enter YouTube URL: " URL
else
    URL="$1"
fi

if [ -z "$URL" ]; then
    echo "Error: No URL provided" >&2
    exit 1
fi

exec "$YTDL" \
    --js-runtimes deno \
    --extractor-args "youtube:player_client=web" \
    --extract-audio \
    --audio-format mp3 \
    --audio-quality 0 \
    --no-part \
    "$URL"
EOF

chmod +x "$SCRIPT_DIR/yt" "$SCRIPT_DIR/ytmp3"
echo "✓ Scripts created: $SCRIPT_DIR/yt, $SCRIPT_DIR/ytmp3"

# Step 6: Add to PATH
echo "[6/6] Adding scripts to PATH..."
if grep -q 'export PATH="\$HOME/scripts:\$PATH"' ~/.bashrc 2>/dev/null; then
    echo "✓ PATH already configured"
else
    echo 'export PATH="$HOME/scripts:$PATH"' >> ~/.bashrc
    echo "✓ PATH configured. Run: source ~/.bashrc"
fi

echo ""
echo "🎉 Installation complete!"
echo ""
echo "To activate, run:"
echo "  source ~/.bashrc"
echo ""
echo "Test with:"
echo "  yt https://www.youtube.com/watch?v=dQw4w9WgXcQ"
echo "  ytmp3 https://www.youtube.com/watch?v=BaW_jOozKJk"
echo ""
echo "See README.md for advanced options and troubleshooting."
