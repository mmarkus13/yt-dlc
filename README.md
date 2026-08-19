<!--````-->
# 🎵 YouTube Downloader CLI

A lightweight command-line YouTube downloader built around [yt-dlp](https://github.com/yt-dlp/yt-dlp), Deno, Python, and FFmpeg.

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

After installation, **reload your shell once (or simply close and re-open)**:

```bash
source ~/.bashrc
```

You can then run `yt` and `ytmp3` from any directory:

```bash
yt "https://youtu.be/VIDEO_ID"
ytmp3 "https://youtu.be/MUSIC_ID"
```

> 💡 **WSL:** The same Bash commands work on Windows 10 and 11 through [Windows Subsystem for Linux (WSL)](https://learn.microsoft.com/en-us/windows/wsl/install).

---

## ✨ Features

| Feature | Description |
|---|---|
| **Video Download** | Downloads the best available video/audio with automatic format selection |
| **Audio Extraction** | Extracts the best available source audio and converts it to MP3 with FFmpeg |
| **Interactive Mode** | Run the wrapper without arguments to prompt for a URL |
| **Playlists** | Download individual videos or entire playlists |
| **Resume Support** | Interrupted downloads can be resumed |
| **Cross-Platform** | Designed for Linux, macOS, and WSL |
| **Python-Based Setup** | Python 3.11+ is used by this setup |
| **Customizable** | Standard yt-dlp options can be passed through the wrappers |

---

## 🎯 Why This Instead of Tartube?

| Feature | This Setup | Tartube |
|---|---|---|
| **Installation** | Simple CLI installer | More involved |
| **Interface** | CLI | GUI |
| **Dependencies** | Python, yt-dlp, Deno, FFmpeg | GUI and backend dependencies |
| **Flexibility** | Full yt-dlp CLI access | GUI-oriented |
| **Resource Usage** | Very lightweight | Higher |
| **Maintenance** | A few scripts + yt-dlp | Multiple application components |
| **Automation** | Excellent | More GUI-oriented |

This project is intended for users who prefer a terminal-based workflow and direct access to yt-dlp's options.

---

# 📋 Prerequisites

### Required

| Component | Minimum / Recommended | Purpose |
|---|---|---|
| **Python** | 3.11+ | Required by this setup |
| **yt-dlp** | Latest stable release | YouTube downloader |
| **Deno** | Current supported version | JavaScript runtime used by yt-dlp for YouTube |
| **FFmpeg** | Current stable version | Video merging and audio conversion |

### Python and yt-dlp

**Python 3.11+ is required by this setup.**

The official standalone yt-dlp executable itself is self-contained and does not require a separate Python installation. However, this project uses Python as part of its overall setup, so Python 3.11 or newer must be available.

If you choose to install yt-dlp through PyPI instead of using the standalone executable, use:

```bash
python3 -m pip install -U "yt-dlp[default]"
```

The `default` dependency group includes the appropriate `yt-dlp-ejs` package. :contentReference[oaicite:2]{index=2}

> **Note:** If you use the official standalone yt-dlp executable, you do **not** need to install `yt-dlp-ejs` separately. The required EJS components are already included in the official executable. :contentReference[oaicite:3]{index=3}

### Why Deno?

yt-dlp uses an external JavaScript runtime to solve JavaScript challenges required for full YouTube extraction.

Deno is the recommended JavaScript runtime for yt-dlp's YouTube support.

---

# 🔧 Detailed / Manual Setup

> **Prefer the easy way?**  
> Use the [Quick Install](#-quick-install) section at the top of this README.

This section is provided for transparency and for users who prefer to install and configure each component manually.

These instructions target Linux, macOS, and WSL (Windows Subsystem for Linux).

---

## 1. Install Python

Python 3.11 or newer is required by this setup.

### Debian / Ubuntu / WSL

```bash
sudo apt update
sudo apt install -y python3 python3-pip
```

Check the installed version:

```bash
python3 --version
```

Make sure it reports Python `3.11` or newer.

If your distribution provides an older Python version by default, install Python 3.11+ using the appropriate package source for your distribution.

### macOS

If you use Homebrew:

```bash
brew install python
```

Verify:

```bash
python3 --version
```

---

## 2. Create the Scripts Directory

```bash
mkdir -p "$HOME/scripts"
```

---

## 3. Install Deno

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

---

## 4. Install yt-dlp

Download the official standalone yt-dlp binary:

```bash
sudo curl -L \
  "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp" \
  -o /usr/local/bin/yt-dlp
```

Make it executable:

```bash
sudo chmod a+rx /usr/local/bin/yt-dlp
```

Verify:

```bash
yt-dlp --version
```

The official standalone executable does not require Python to run. Python remains a requirement of this overall `yt-dlc` setup.

---

## 5. Install FFmpeg

### Debian / Ubuntu / WSL

```bash
sudo apt update
sudo apt install -y ffmpeg
```

Verify:

```bash
ffmpeg -version
```

FFmpeg is strongly recommended because yt-dlp often needs it to merge separate video/audio streams and convert audio.

### macOS

If you use Homebrew:

```bash
brew install ffmpeg
```

Verify:

```bash
ffmpeg -version
```

---

## 6. Install the Wrapper Scripts

### Option A — Clone the Repository

Clone the repository:

```bash
git clone "https://github.com/mmarkus13/yt-dlc.git" \
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

## 7. Add `~/scripts` to Your PATH

Add the scripts directory to your Bash `PATH`:

```bash
echo 'export PATH="$HOME/scripts:$PATH"' >> "$HOME/.bashrc"
```

Reload:

```bash
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
/usr/local/bin/yt-dlp
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

## Download into a Specific Directory

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

### Don't Overwrite Existing Files

```bash
yt --no-overwrites "https://youtu.be/VIDEO_ID"
```

### Add a Delay Between Downloads

```bash
yt \
  --sleep-interval 3 \
  --max-sleep-interval 6 \
  "https://youtu.be/VIDEO_ID"
```

### Specify a Country for Geo-Restricted Content

```bash
yt \
  --geo-bypass-country US \
  "https://youtu.be/VIDEO_ID"
```

> Geo-bypass options cannot defeat every form of regional restriction. Availability depends on how the content is restricted.

---

# 📁 Recommended Directory Structure

After installation, your system can look like this:

```text
~
├── scripts/
│   ├── yt
│   └── ytmp3
│
└── yt-dlc/
    ├── README.md
    ├── installer.sh
    ├── yt
    └── ytmp3

/usr/local/bin/
└── yt-dlp
```

Downloaded media can be stored wherever you choose, for example:

```text
~/Downloads/
└── YouTube downloads

~/Music/
└── MP3 downloads
```

---

# 🔧 Troubleshooting

## `python3: command not found`

Check Python:

```bash
python3 --version
```

If it is missing, install Python 3.11+ using your operating system's package manager.

On Debian / Ubuntu:

```bash
sudo apt update
sudo apt install -y python3 python3-pip
```

---

## Python Version Warning

Check your version:

```bash
python3 --version
```

This project requires Python `3.11` or newer.

---

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

---

## `no such option: --js-runtimes`

Your yt-dlp version is probably too old.

Update it:

```bash
sudo yt-dlp -U
```

Then:

```bash
yt-dlp --version
```

---

## `HTTP Error 403: Forbidden`

First update yt-dlp:

```bash
sudo yt-dlp -U
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
python3 --version
yt-dlp --version
deno --version
ffmpeg -version
which yt
which ytmp3
which yt-dlp
```

You should have Python `3.11+`.

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

Because the standalone binary is installed in `/usr/local/bin`:

```bash
sudo yt-dlp -U
```

Verify:

```bash
yt-dlp --version
```

Keeping yt-dlp updated is particularly important because YouTube changes frequently and yt-dlp releases regularly contain extractor fixes.

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

- **[yt-dlp](https://github.com/yt-dlp/yt-dlp)** — Unlicense
- **[Deno](https://deno.com/)** — MIT
- **[yt-dlp-ejs](https://github.com/yt-dlp/ejs)** — MIT

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

# 📌 Important Notes

- Keep yt-dlp updated because YouTube changes frequently.
- Keep Deno updated and use a currently supported version.
- Python 3.11+ is required by this `yt-dlc` setup.
- FFmpeg is required for many video/audio processing operations.
- The official standalone yt-dlp executable already includes the EJS components required for YouTube support. :contentReference[oaicite:4]{index=4}
- If you install yt-dlp through PyPI instead, use `yt-dlp[default]`.
- A separate `pip install yt-dlp-ejs` is not required when using the official standalone executable. :contentReference[oaicite:5]{index=5}
- Avoid relying on permanently hard-coded YouTube client workarounds.
- Only download content you have the right to download and use.

---

**Happy downloading! 🎵**

*Last tested: August 2026 · yt-dlp `2026.07.04` · Deno `2.9.5`*
