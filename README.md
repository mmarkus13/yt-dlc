# 🎵 YouTube Downloader CLI

A lightweight command-line YouTube downloader built around **yt-dlp**, **Deno**, and **FFmpeg**.

No GUI bloat, no complicated configuration — just a small set of wrapper scripts for downloading video and audio from the command line.

> **Status:** Tested in August 2026 with yt-dlp `2026.07.04` and Deno `2.9.5`.

---

## 🚀 Quick Install

> **Install everything with a single command block:**

```bash
mkdir -p ~/scripts && cd ~/scripts && \
curl -fsSL "https://raw.githubusercontent.com/mmarkus13/yt-dlc/main/installer.sh" \
  -o installer.sh && \
chmod +x installer.sh && \
./installer.sh
```

The installer:

- Creates `~/scripts`
- Installs Deno
- Downloads the official standalone yt-dlp executable
- Creates the `yt` and `ytmp3` wrapper scripts
- Adds `~/scripts` to your Bash `PATH`
- Checks for FFmpeg and asks whether it should be installed when appropriate

After installation, **reload your shell once**:

```bash
source ~/.bashrc
```

You can then run `yt` and `ytmp3` from any directory:

```bash
yt "https://youtu.be/VIDEO_ID"
ytmp3 "https://youtu.be/MUSIC_ID"
```

> 💡 **Platforms:** The same Bash-based workflow is designed for Linux, macOS, SteamOS, and Windows 10/11 through Windows Subsystem for Linux (WSL).

---

## ✨ Features

| Feature | Description |
|---|---|
| **Video Download** | Downloads the best available video/audio and produces an MP4 when possible |
| **Audio Extraction** | Extracts the best available audio and converts it to MP3 with FFmpeg |
| **Interactive Mode** | Run the wrapper without arguments to prompt for a URL |
| **Playlists** | Download individual videos or entire playlists |
| **Resume Support** | Interrupted downloads can normally be resumed |
| **Cross-Platform** | Designed for Linux, macOS, SteamOS, and WSL |
| **Minimal Setup** | Uses the official standalone yt-dlp executable |
| **No Python Required** | The standalone yt-dlp executable does not require Python |
| **Customizable** | Standard yt-dlp options can be passed through the wrappers |
| **User-Local Installation** | yt-dlp and the wrapper scripts live under `~/scripts` |

---

## 🎯 Why This Instead of Tartube?

| Feature | This Setup | Tartube |
|---|---|---|
| **Installation** | ~5 minutes | More involved |
| **Interface** | CLI | GUI |
| **Dependencies** | yt-dlp, Deno, FFmpeg | GUI and backend dependencies |
| **Flexibility** | Full yt-dlp CLI access | GUI-oriented |
| **Resource Usage** | Very lightweight | Higher |
| **Maintenance** | A few scripts + yt-dlp | Multiple application components |
| **Automation** | Excellent | More GUI-oriented |

This project is intended for users who prefer a terminal-based workflow and direct access to yt-dlp's options.

---

# 📋 Prerequisites

### Required

| Component | Required | Purpose |
|---|---|---|
| **yt-dlp** | Yes | YouTube downloader |
| **Deno** | Yes | JavaScript runtime used by yt-dlp for YouTube |
| **FFmpeg** | Yes for MP3/conversion | Video merging, audio extraction, and format conversion |
| **Python** | **No** | The official standalone yt-dlp executable does not require Python |

The automated installer installs **yt-dlp** and **Deno** into `~/scripts` / `~/.deno`.

FFmpeg is detected automatically. If it is missing, the installer asks whether you want to install it when automatic installation is appropriate.

> **Important:** This project uses the official standalone yt-dlp executable. It does **not** install yt-dlp through `pip` and does **not** require Python.

### Why Deno?

yt-dlp uses an external JavaScript runtime to solve JavaScript challenges required for full YouTube extraction.

Deno is the recommended JavaScript runtime for yt-dlp's YouTube support and is enabled by default by current yt-dlp releases.

### Why FFmpeg?

FFmpeg is used by yt-dlp for operations such as:

- Merging separate video and audio streams
- Converting video formats
- Extracting audio
- Converting extracted audio to MP3

Without FFmpeg, basic downloads may still work, but operations requiring merging or conversion can fail.

---

# 🔧 Detailed / Manual Setup

> **Prefer the easy way?**  
> Use the [Quick Install](#-quick-install) section at the top of this README.

This section is provided for transparency and for users who prefer to install and configure each component manually.

These instructions target **Linux, macOS, SteamOS, and WSL** (Windows Subsystem for Linux).

---

## 1. Create the Scripts Directory

```bash
mkdir -p "$HOME/scripts"
```

---

## 2. Install Deno

Install Deno using the official installer:

```bash
curl -fsSL https://deno.land/install.sh | sh
```

Add Deno to your Bash `PATH`:

```bash
echo 'export DENO_INSTALL="$HOME/.deno"' >> "$HOME/.bashrc"
echo 'export PATH="$DENO_INSTALL/bin:$PATH"' >> "$HOME/.bashrc"
source "$HOME/.bashrc"
```

Verify the installation:

```bash
deno --version
```

If you use Zsh instead of Bash, add the environment variables to `~/.zshrc` instead.

> Deno's official installer places the executable under `~/.deno/bin` on Linux and macOS.

---

## 3. Install yt-dlp

Download the official standalone yt-dlp executable:

```bash
curl -fsSL \
  "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp" \
  -o "$HOME/scripts/yt-dlp"
```

Make it executable:

```bash
chmod +x "$HOME/scripts/yt-dlp"
```

Verify:

```bash
"$HOME/scripts/yt-dlp" --version
```

The official standalone executable does **not** require Python.

It also already contains the EJS components required by yt-dlp, so a separate `pip install yt-dlp-ejs` is not required.

---

## 4. Install FFmpeg

### Debian / Ubuntu / WSL

```bash
sudo apt update
sudo apt install -y ffmpeg
```

Verify:

```bash
ffmpeg -version
```

### macOS

If you use Homebrew:

```bash
brew install ffmpeg
```

Verify:

```bash
ffmpeg -version
```

### SteamOS

SteamOS uses an immutable/read-only system design for its normal operating environment.

This project intentionally does **not** require installing yt-dlp system-wide or modifying `/usr/local/bin`.

If FFmpeg is already available, verify it with:

```bash
ffmpeg -version
```

If FFmpeg is missing, see the SteamOS section below before modifying the system installation.

> **SteamOS warning:** System packages installed manually outside the supported SteamOS mechanisms may be affected or removed by future SteamOS updates. This project therefore avoids automatically modifying the SteamOS system image.

---

## 5. Install the Wrapper Scripts

### Option A — Clone the Repository

Clone the repository:

```bash
git clone \
  "https://github.com/mmarkus13/yt-dlc.git" \
  "$HOME/yt-dlc"
```

Copy the wrapper scripts:

```bash
cp "$HOME/yt-dlc/yt" "$HOME/scripts/yt"
cp "$HOME/yt-dlc/ytmp3" "$HOME/scripts/ytmp3"
```

Make them executable:

```bash
chmod +x "$HOME/scripts/yt" "$HOME/scripts/ytmp3"
```

### Option B — Download the Wrapper Scripts Directly

```bash
curl -fsSL \
  "https://raw.githubusercontent.com/mmarkus13/yt-dlc/main/yt" \
  -o "$HOME/scripts/yt"

curl -fsSL \
  "https://raw.githubusercontent.com/mmarkus13/yt-dlc/main/ytmp3" \
  -o "$HOME/scripts/ytmp3"

chmod +x "$HOME/scripts/yt" "$HOME/scripts/ytmp3"
```

---

## 6. Add `~/scripts` to Your PATH

```bash
echo 'export PATH="$HOME/scripts:$PATH"' >> "$HOME/.bashrc"
source "$HOME/.bashrc"
```

Verify:

```bash
which yt
which ytmp3
which yt-dlp
```

You should see paths similar to:

```text
/home/yourname/scripts/yt
/home/yourname/scripts/ytmp3
/home/yourname/scripts/yt-dlp
```

---

# 🎬 Usage

## Download a Video

```bash
yt "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
```

Or:

```bash
yt "https://youtu.be/VIDEO_ID"
```

---

## Download Audio as MP3

```bash
ytmp3 "https://www.youtube.com/watch?v=MUSIC_ID"
```

For example:

```bash
cd "$HOME/Music"
ytmp3 "https://youtu.be/MUSIC_ID"
```

---

## Download Into a Specific Directory

Change directories before running the command:

```bash
cd "$HOME/Downloads"
yt "https://youtu.be/VIDEO_ID"
```

For music:

```bash
cd "$HOME/Music"
ytmp3 "https://youtu.be/MUSIC_ID"
```

The wrappers use the current working directory as the download destination unless their configuration has been customized.

---

# 📚 Playlists

Download an entire playlist:

```bash
yt "https://www.youtube.com/playlist?list=PLAYLIST_ID"
```

Download only the first five entries:

```bash
yt --playlist-end 5 \
  "https://www.youtube.com/playlist?list=PLAYLIST_ID"
```

Ignore videos that fail:

```bash
yt --ignore-errors \
  "https://www.youtube.com/playlist?list=PLAYLIST_ID"
```

---

# ⚙️ Advanced Options

The wrappers pass standard yt-dlp options through, so normal yt-dlp arguments can be used.

## Don't Overwrite Existing Files

```bash
yt --no-overwrites "https://youtu.be/VIDEO_ID"
```

---

## Add a Delay Between Downloads

```bash
yt \
  --sleep-interval 3 \
  --max-sleep-interval 6 \
  "https://youtu.be/VIDEO_ID"
```

For playlists:

```bash
yt \
  --sleep-interval 3 \
  --max-sleep-interval 6 \
  "https://www.youtube.com/playlist?list=PLAYLIST_ID"
```

---

## Specify a Country for Geo-Restricted Content

```bash
yt \
  --geo-bypass-country US \
  "https://youtu.be/VIDEO_ID"
```

> Geo-bypass options cannot defeat every form of regional restriction. Availability depends on how the content is restricted.

---

# 📁 Recommended Directory Structure

After installation, your home directory can look like this:

```text
~
├── scripts/
│   ├── yt
│   ├── ytmp3
│   └── yt-dlp
│
├── Downloads/
│   └── YouTube downloads
│
├── Music/
│   └── MP3 downloads
│
└── yt-dlc/
    ├── README.md
    ├── installer.sh
    ├── yt
    └── ytmp3
```

---

# 🔧 Troubleshooting

## `deno: command not found`

Reload your shell:

```bash
source "$HOME/.bashrc"
```

Then:

```bash
deno --version
```

If that still fails:

```bash
echo "$DENO_INSTALL"
echo "$PATH"
```

You should normally see:

```text
/home/yourname/.deno
```

in the Deno installation path.

If you use Zsh:

```bash
source "$HOME/.zshrc"
```

---

## YouTube Reports That No JavaScript Runtime Was Found

Check Deno:

```bash
deno --version
```

Then:

```bash
which deno
```

Verify yt-dlp:

```bash
yt-dlp --version
```

Also check that your yt-dlp binary is the one you expect:

```bash
which yt-dlp
```

The official standalone yt-dlp executable already includes the required EJS components.

---

## `no such option: --js-runtimes`

Your yt-dlp version is probably too old.

Update it:

```bash
yt-dlp -U
```

Or:

```bash
"$HOME/scripts/yt-dlp" -U
```

Then:

```bash
yt-dlp --version
```

---

## `HTTP Error 403: Forbidden`

First update yt-dlp:

```bash
yt-dlp -U
```

Then check Deno:

```bash
deno --version
```

And FFmpeg:

```bash
ffmpeg -version
```

Avoid permanently hard-coding a specific YouTube `player_client` unless there is a current, reproducible reason to do so.

YouTube's available clients and extraction requirements change over time, and yt-dlp regularly updates its YouTube extractor.

---

## `HTTP Error 416: Range Not Satisfiable`

A partial download may be corrupted or incompatible with the current request.

Find partial files:

```bash
find . -type f \( \
  -name "*.part" \
  -o -name "*.part-Frag*" \
  -o -name "*.ytdl" \
\) -print
```

Remove them if appropriate:

```bash
find . -type f \( \
  -name "*.part" \
  -o -name "*.part-Frag*" \
  -o -name "*.ytdl" \
\) -delete
```

Then retry the download.

> The wrappers do not disable yt-dlp's normal partial-download behavior, so interrupted downloads can normally be resumed.

---

## `unknown preset alias`

Make sure you're using the correct yt-dlp option syntax.

Correct:

```bash
--extract-audio
```

Incorrect:

```bash
-extract-audio
```

---

## Python Version Warnings

If you are using the standalone yt-dlp executable provided by this project, Python is not involved.

You only need Python if you deliberately choose to install yt-dlp through Python/PyPI instead.

If you use the PyPI installation method, follow the current yt-dlp requirements for the supported Python version and install the `default` dependency group:

```bash
python3 -m pip install -U "yt-dlp[default]"
```

---

## FFmpeg Is Missing

Check:

```bash
ffmpeg -version
```

If the command is not found, install FFmpeg using the appropriate method for your operating system.

FFmpeg is required for:

- MP3 extraction
- Audio conversion
- Merging separate video/audio streams
- Some video format conversions

On Debian/Ubuntu/WSL:

```bash
sudo apt update
sudo apt install -y ffmpeg
```

On macOS with Homebrew:

```bash
brew install ffmpeg
```

For SteamOS, see the SteamOS section before installing system packages.

---

# 🧹 Cleaning Partial Downloads

To find partial files in your home directory:

```bash
find "$HOME" -type f \( \
  -name "*.part" \
  -o -name "*.ytdl" \
  -o -name "*.temp" \
\) -print
```

To delete them:

```bash
find "$HOME" -type f \( \
  -name "*.part" \
  -o -name "*.ytdl" \
  -o -name "*.temp" \
\) -delete
```

> Review the files first if you have other applications that use similarly named temporary files.

---

# ✅ Verify the Installation

Run:

```bash
yt-dlp --version
deno --version
which yt
which ytmp3
which yt-dlp
```

If FFmpeg is installed, also verify it:

```bash
ffmpeg -version
```

Then test a video:

```bash
yt "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
```

And test audio extraction:

```bash
ytmp3 "https://www.youtube.com/watch?v=BaW_jOozKJk"
```

---

# 🔄 Updating

## Update yt-dlp

Because you're using the standalone binary:

```bash
yt-dlp -U
```

Or:

```bash
"$HOME/scripts/yt-dlp" -U
```

Keeping yt-dlp updated is particularly important because YouTube changes frequently and yt-dlp releases regularly contain extractor fixes.

---

## Update Deno

If Deno was installed using the official installer:

```bash
deno upgrade
```

Then verify:

```bash
deno --version
```

---

# 🖥️ WSL Notes

This setup works well under WSL.

Windows drives are mounted under `/mnt`.

For example:

```bash
cd /mnt/c/Users/YourName/Music
ytmp3 "https://youtu.be/MUSIC_ID"
```

A Windows path such as:

```text
C:\Users\YourName\Music
```

becomes:

```text
/mnt/c/Users/YourName/Music
```

The WSL installation should use the Linux-side `~/scripts` directory rather than attempting to install the tools into the Windows filesystem.

---

# 🎮 SteamOS

This project also works on **SteamOS**, including Steam Deck systems.

The installation is intentionally user-local:

```text
~/scripts/
├── yt-dlp
├── yt
└── ytmp3
```

The installer does not require yt-dlp to be installed system-wide and does not need to place anything in `/usr/local/bin`.

This approach is particularly useful on SteamOS because the operating system uses a read-only/immutable system design for its normal operating environment.

### FFmpeg on SteamOS

FFmpeg is required for MP3 extraction and some video conversions.

The installer checks whether FFmpeg is already available.

If FFmpeg is missing, the installer does **not** blindly modify the SteamOS system installation.

Instead, it informs you that FFmpeg is required and that it needs to be installed using a SteamOS-appropriate method.

> **Important:** Manually installed system packages can be affected by SteamOS updates. This project therefore keeps yt-dlp and the wrapper scripts in the user's home directory and avoids modifying the SteamOS system image.

### SteamOS Download Locations

The wrappers can be used from normal SteamOS directories:

```bash
cd "$HOME/Downloads"
yt "https://youtu.be/VIDEO_ID"
```

Or:

```bash
cd "$HOME/Music"
ytmp3 "https://youtu.be/MUSIC_ID"
```

---

# 🌍 Region Restrictions

Some content is region restricted.

You can try:

```bash
yt \
  --geo-bypass-country US \
  "https://youtu.be/VIDEO_ID"
```

However, this does **not** guarantee access to content that requires authentication, a subscription, a specific location, or another form of access control.

---

# 🔐 DRM Content

This project does **not** bypass DRM.

yt-dlp can download supported streams that are legitimately exposed to the downloader, but DRM-protected content cannot simply be downloaded by adding a yt-dlp option.

---

# 🐢 Rate Limiting

If you're downloading many videos, you can add delays:

```bash
yt \
  --sleep-interval 3 \
  --max-sleep-interval 6 \
  "https://youtu.be/VIDEO_ID"
```

For playlists:

```bash
yt \
  --sleep-interval 3 \
  --max-sleep-interval 6 \
  "https://www.youtube.com/playlist?list=PLAYLIST_ID"
```

---

# 🔧 Customization

## Change the Default Output Directory

Edit the `yt` wrapper:

```bash
nano "$HOME/scripts/yt"
```

Configure the yt-dlp output template.

For example:

```bash
-o "$HOME/Downloads/youtube/%(title)s.%(ext)s"
```

Create the directory first:

```bash
mkdir -p "$HOME/Downloads/youtube"
```

---

## Use an Environment Variable

Add this to `~/.bashrc`:

```bash
export YOUTUBE_DL_OUTPUT="$HOME/Downloads/youtube"
```

Reload:

```bash
source "$HOME/.bashrc"
```

Then the wrapper can use:

```bash
OUTPUT_DIR="${YOUTUBE_DL_OUTPUT:-$PWD}"
```

and:

```bash
-o "$OUTPUT_DIR/%(title)s.%(ext)s"
```

This lets you change the destination without editing the wrapper.

---

# 📜 License

This project consists primarily of wrapper scripts around third-party software.

- **yt-dlp** — Unlicense
- **Deno** — MIT
- **yt-dlp-ejs** — MIT

See the respective upstream projects for their complete license information.

The wrapper scripts in this repository are provided as-is.

---

# 🙏 Credits

This project exists for users who prefer:

- A pure CLI workflow
- Minimal resource usage
- Simple maintenance
- Direct access to yt-dlp options
- Easy scripting and automation

Special thanks to:

- The **yt-dlp** maintainers and contributors
- The **Deno** project
- The **yt-dlp-ejs** contributors

---

# 🤝 Contributing

Contributions are welcome.

Possible improvements include:

- Thumbnail extraction
- Metadata embedding
- Artist/album metadata for music
- Cover-art embedding
- Playlist-to-folder organization
- Better retry handling
- Exponential backoff
- Desktop notifications
- Additional supported platforms
- Improved installation automation
- Shell completion
- Configuration-file support

---

# 🧪 Development / Testing

Test the wrappers directly from the repository:

```bash
./yt "https://youtu.be/VIDEO_ID"
```

```bash
./ytmp3 "https://youtu.be/MUSIC_ID"
```

Make sure they are executable:

```bash
chmod +x yt ytmp3
```

---

# 🚀 Publishing to GitHub

Create the repository directory:

```bash
mkdir -p "$HOME/yt-dlc"
cd "$HOME/yt-dlc"
```

Copy the wrapper files:

```bash
cp "$HOME/scripts/yt" .
cp "$HOME/scripts/ytmp3" .
```

Copy the installer:

```bash
cp "$HOME/scripts/installer.sh" .
```

Create the README:

```bash
nano README.md
```

Initialize Git:

```bash
git init
git add .
git commit -m "Initial release: YouTube downloader CLI"
```

Create an empty GitHub repository named:

```text
yt-dlc
```

Then configure the remote using your own GitHub username:

```bash
git remote add origin \
  "https://github.com/YOUR_USERNAME/yt-dlc.git"

git branch -M main
git push -u origin main
```

> Replace `YOUR_USERNAME` with your actual GitHub username in this publishing command only.

---

# ⚡ Quick Start

Once the repository is published, a new Linux/WSL/SteamOS installation can use the automated installer:

```bash
mkdir -p ~/scripts && cd ~/scripts && \
curl -fsSL "https://raw.githubusercontent.com/mmarkus13/yt-dlc/main/installer.sh" \
  -o installer.sh && \
chmod +x installer.sh && \
./installer.sh
```

Then reload the shell:

```bash
source ~/.bashrc
```

Verify:

```bash
yt-dlp --version
deno --version
which yt
which ytmp3
```

If FFmpeg is installed:

```bash
ffmpeg -version
```

Then download:

```bash
yt "https://youtu.be/VIDEO_ID"
```

Or extract audio:

```bash
ytmp3 "https://youtu.be/MUSIC_ID"
```

---

# 📌 Important Notes

- Keep yt-dlp updated because YouTube changes frequently.
- Keep Deno updated and use a currently supported version.
- FFmpeg is required for MP3 extraction and many video/audio processing operations.
- The official standalone yt-dlp executable includes the required EJS components.
- A separate `pip install yt-dlp-ejs` is **not** required for this standalone-binary setup.
- Python is **not required** when using the official standalone yt-dlp executable.
- If you deliberately install yt-dlp through PyPI instead, use the `yt-dlp[default]` dependency group.
- Avoid relying on permanently hard-coded YouTube client workarounds.
- The installer keeps yt-dlp and the wrapper scripts in the user's home directory.
- The installer does not require system-wide yt-dlp installation.
- SteamOS is supported without requiring modifications to the SteamOS system image.
- Only download content you have the right to download and use.

---

**Happy downloading! 🎵**

*Last tested: August 2026 · yt-dlp `2026.07.04` · Deno `2.9.5`*
