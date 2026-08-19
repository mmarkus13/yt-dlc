<!--````-->
# 🎵 YouTube Downloader CLI

A lightweight command-line YouTube downloader built around [yt-dlp](https://github.com/yt-dlp/yt-dlp), Deno, and FFmpeg.

No GUI bloat, no complicated configuration — just a small set of wrapper scripts for downloading video and audio from the command line.

> **Status:** Tested in August 2026 with yt-dlp `2026.07.04` and Deno `2.9.5`.

---

# **Install everything with a single command:**

> bash
```
mkdir -p ~/scripts && cd ~/scripts && \
curl -fsSL "https://raw.githubusercontent.com/mmarkus13/yt-dlc/main/installer.sh" \
  -o installer.sh && \
chmod +x installer.sh && \
./installer.sh
```
> then before first usage don't forget to reload your shell: \
`source ~/.bashrc`

> *#note: bash commands works under [Windows (10 & 11) WSL](https://learn.microsoft.com/en-us/windows/wsl/install) as well!*
---

## ✨ Features

| Feature | Description |
|---|---|
| **Video Download** | Downloads the best available video/audio and produces an MP4 when possible |
| **Audio Extraction** | Extracts the best available audio and converts it to MP3 with FFmpeg |
| **Interactive Mode** | Run the wrapper without arguments to prompt for a URL |
| **Playlists** | Download individual videos or entire playlists |
| **Resume Support** | Interrupted downloads can be resumed |
| **Cross-Platform** | Designed for Linux, macOS, and WSL |
| **Minimal Setup** | Uses the official yt-dlp binary instead of a Python installation |
| **Customizable** | Standard yt-dlp options can be passed through the wrappers |

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

| Component | Recommended | Purpose |
|---|---|---|
| **yt-dlp** | Latest stable release | YouTube downloader |
| **Deno** | Current supported version | JavaScript runtime used by yt-dlp for YouTube |
| **FFmpeg** | Current stable version | Video merging and audio conversion |

### Python?

**Python is not required** when using the official standalone yt-dlp binary.

This README uses the official standalone yt-dlp executable, so there is no need to install yt-dlp through `pip`.

If you choose to install yt-dlp through PyPI instead, use:

```bash
python3 -m pip install -U "yt-dlp[default]"
```

This installs the default dependencies, including the appropriate EJS package.

### Why Deno?

yt-dlp uses an external JavaScript runtime to solve JavaScript challenges required for full YouTube extraction.

Deno is the recommended JavaScript runtime for yt-dlp's YouTube support.

---

# 🚀 Detailed Setup
> #note: this is for transparency; if you'd like a quick & easy install head back to the [top](https://github.com/mmarkus13/yt-dlc/tree/main#user-content-install-everything-with-a-single-command) of the page...

These instructions target Linux, macOS, and WSL.

## 1. Create the scripts directory

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

---

## 3. Install yt-dlp

Download the official standalone yt-dlp binary:

```bash
curl -L \
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

The standalone binary does not require Python.

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

## 5. Install the wrapper scripts

### Option A — Clone the repository

Replace `YOUR_USERNAME` with your GitHub username:

```bash
git clone \
  "https://github.com/YOUR_USERNAME/youtube-downloader-cli.git" \
  "$HOME/youtube-downloader-cli"
```

Copy the wrappers:

```bash
cp "$HOME/youtube-downloader-cli/yt" "$HOME/scripts/yt"
cp "$HOME/youtube-downloader-cli/ytmp3" "$HOME/scripts/ytmp3"
```

Make them executable:

```bash
chmod +x "$HOME/scripts/yt" "$HOME/scripts/ytmp3"
```

### Option B — Download the wrappers directly

```bash
curl -L \
  "https://raw.githubusercontent.com/YOUR_USERNAME/youtube-downloader-cli/main/yt" \
  -o "$HOME/scripts/yt"

curl -L \
  "https://raw.githubusercontent.com/YOUR_USERNAME/youtube-downloader-cli/main/ytmp3" \
  -o "$HOME/scripts/ytmp3"

chmod +x "$HOME/scripts/yt" "$HOME/scripts/ytmp3"
```

---

## 6. Add `~/scripts` to your PATH

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

## Download a video

```bash
yt "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
```

Or:

```bash
yt "https://youtu.be/VIDEO_ID"
```

---

## Download audio as MP3

```bash
ytmp3 "https://www.youtube.com/watch?v=MUSIC_ID"
```

For example:

```bash
cd "$HOME/Music"
ytmp3 "https://youtu.be/MUSIC_ID"
```

---

## Download into a specific directory

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

### Don't overwrite existing files

```bash
yt --no-overwrites "https://youtu.be/VIDEO_ID"
```

### Add a delay between downloads

```bash
yt \
  --sleep-interval 3 \
  --max-sleep-interval 6 \
  "https://youtu.be/VIDEO_ID"
```

### Specify a country for geo-restricted content

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
└── youtube-downloader-cli/
    ├── README.md
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

## YouTube reports that no JavaScript runtime was found

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

## Python version warnings

If you are using the standalone yt-dlp binary from this README, Python is not involved.

If you installed yt-dlp through Python/pip, make sure you're using a currently supported Python version.

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
ffmpeg -version
which yt
which ytmp3
which yt-dlp
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

# 🚀 Publishing to GitHub

Create the repository directory:

```bash
mkdir -p "$HOME/youtube-downloader-cli"
cd "$HOME/youtube-downloader-cli"
```

Copy the wrapper files:

```bash
cp "$HOME/scripts/yt" .
cp "$HOME/scripts/ytmp3" .
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
youtube-downloader-cli
```

Then configure the remote:

```bash
git remote add origin \
  "https://github.com/YOUR_USERNAME/youtube-downloader-cli.git"

git branch -M main
git push -u origin main
```

---

# ⚡ Quick Start

Once the repository is published, a new Linux/WSL installation can follow:

```bash
git clone \
  "https://github.com/YOUR_USERNAME/youtube-downloader-cli.git" \
  "$HOME/youtube-downloader-cli"

mkdir -p "$HOME/scripts"

cp "$HOME/youtube-downloader-cli/yt" "$HOME/scripts/yt"
cp "$HOME/youtube-downloader-cli/ytmp3" "$HOME/scripts/ytmp3"

chmod +x "$HOME/scripts/yt" "$HOME/scripts/ytmp3"

curl -fsSL https://deno.land/install.sh | sh

echo 'export DENO_INSTALL="$HOME/.deno"' >> "$HOME/.bashrc"
echo 'export PATH="$DENO_INSTALL/bin:$HOME/scripts:$PATH"' >> "$HOME/.bashrc"

source "$HOME/.bashrc"

curl -L \
  "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp" \
  -o "$HOME/scripts/yt-dlp"

chmod +x "$HOME/scripts/yt-dlp"

sudo apt update
sudo apt install -y ffmpeg
```

Verify:

```bash
yt-dlp --version
deno --version
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
- FFmpeg is required for many video/audio processing operations.
- The official standalone yt-dlp binary includes the EJS scripts needed by yt-dlp.
- A separate `pip install yt-dlp-ejs` is therefore not required for this standalone-binary setup.
- If you install yt-dlp through PyPI instead, use `yt-dlp[default]`.
- Avoid relying on permanently hard-coded YouTube client workarounds.
- Only download content you have the right to download and use.

---

**Happy downloading! 🎵**

*Last tested: August 2026 · yt-dlp `2026.07.04` · Deno `2.9.5`*
````
