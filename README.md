# 🎵 YouTube Downloader CLI

A lightweight command-line YouTube downloader built around [yt-dlp](https://github.com/yt-dlp/yt-dlp), Deno, and FFmpeg.

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

The installer will:

- Install Deno if it is not already installed
- Download the latest standalone yt-dlp binary
- Check for FFmpeg and ask whether you want to install it if it is missing
- Download the `yt` and `ytmp3` wrapper scripts
- Add `~/scripts` to your `PATH`
- Configure the current shell session

After installation, you can run `yt` and `ytmp3` from any directory:

```bash
yt "https://youtu.be/VIDEO_ID"
ytmp3 "https://youtu.be/MUSIC_ID"
```

> 💡 **WSL:** The same Bash commands work on Windows 10 and 11 through [Windows Subsystem for Linux (WSL)](https://learn.microsoft.com/en-us/windows/wsl/install).

> 💡 **SteamOS:** This setup can also be used on SteamOS. \
> The manual installation may require additional steps depending on your SteamOS version and package-management configuration.

---

## ✨ Features

| Feature | Description |
|---|---|
| **Video Download** | Downloads the best available video/audio and produces an MP4 when possible |
| **Audio Extraction** | Extracts the best available audio and converts it to MP3 with FFmpeg |
| **Interactive Mode** | Run the wrapper without arguments to prompt for a URL |
| **Batch Downloads** | Download multiple individual URLs without creating a playlist |
| **Batch Files** | Pass a text file containing multiple URLs directly to yt-dlp |
| **Playlists** | Download individual videos or entire YouTube playlists |
| **Resume Support** | Interrupted downloads can be resumed |
| **Cross-Platform** | Designed for Linux, macOS, WSL, and SteamOS |
| **Minimal Setup** | Uses the official standalone yt-dlp binary |
| **Customizable** | Standard yt-dlp options can be passed through the wrappers |
| **CLI Workflow** | Designed for scripting, automation, and terminal use |

---

# 🎯 Why This Instead of Tartube?

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

The automated installer handles these dependencies where possible.

### Python

For this project's **standalone-binary setup**, Python is **not required to run yt-dlp itself**.

The official standalone yt-dlp binary includes what it needs to run independently of a system Python installation.

However, **Python 3.11 or newer is required if you choose to install yt-dlp through PyPI instead of using the standalone binary**.

For a Python-based installation:

```bash
python3 --version
```

Then install yt-dlp with:

```bash
python3 -m pip install -U "yt-dlp[default]"
```

This installs the default dependencies required by the PyPI version.

> **Recommended for this project:** Use the official standalone yt-dlp binary installed by `installer.sh`. This avoids requiring Python solely for yt-dlp.

### Why Deno?

yt-dlp uses an external JavaScript runtime to handle JavaScript challenges required for full YouTube extraction.

Deno is the recommended JavaScript runtime for yt-dlp's YouTube support.

---

# 🔧 Detailed / Manual Setup

> **Prefer the easy way?**  
> Use the [Quick Install](#-quick-install) section at the top of this README.

This section is provided for transparency and for users who prefer to install and configure each component manually.

These instructions target Linux, macOS, WSL, and SteamOS where the required tools can be installed normally.

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

FFmpeg is strongly recommended because yt-dlp often needs it to merge separate video/audio streams and convert audio.

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

SteamOS is Arch Linux-based, but its system filesystem and package-management behavior can differ from a conventional Arch installation.

If FFmpeg is already available:

```bash
ffmpeg -version
```

If it is missing, follow the current SteamOS-specific package-management guidance appropriate for your SteamOS version.

The automated installer will detect whether FFmpeg is already available and, when possible, ask whether you want to install it.

---

## 5. Install the Wrapper Scripts

The repository contains two version-controlled wrapper scripts:

```text
yt
ytmp3
```

They are the single source of truth for the wrapper implementations.

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

If you don't want to clone the repository, download the wrapper scripts directly:

```bash
curl -fsSL \
  "https://raw.githubusercontent.com/mmarkus13/yt-dlc/main/yt" \
  -o "$HOME/scripts/yt"

curl -fsSL \
  "https://raw.githubusercontent.com/mmarkus13/yt-dlc/main/ytmp3" \
  -o "$HOME/scripts/ytmp3"

chmod +x "$HOME/scripts/yt" "$HOME/scripts/ytmp3"
```

This installs only the wrapper scripts.

You must still install yt-dlp, Deno, FFmpeg, and configure `~/scripts` in your `PATH` separately.

---

## 6. Add `~/scripts` to Your PATH

For Bash:

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

> If the PATH entry already exists, do not add it again.

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

## Download Multiple Individual URLs

You can provide multiple URLs directly without creating a playlist:

```bash
yt \
  "https://youtu.be/VIDEO_ID_1" \
  "https://youtu.be/VIDEO_ID_2" \
  "https://youtu.be/VIDEO_ID_3"
```

For audio:

```bash
ytmp3 \
  "https://youtu.be/MUSIC_ID_1" \
  "https://youtu.be/MUSIC_ID_2" \
  "https://youtu.be/MUSIC_ID_3"
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

# 📚 Multiple Videos, Songs & Playlists

You don't need to create a YouTube playlist to download multiple items.

The wrappers accept multiple URLs in a single command.

## Download Multiple Videos

```bash
yt \
  "https://youtu.be/VIDEO_ID_1" \
  "https://youtu.be/VIDEO_ID_2" \
  "https://youtu.be/VIDEO_ID_3"
```

## Download Multiple Songs as MP3

```bash
ytmp3 \
  "https://youtu.be/MUSIC_ID_1" \
  "https://youtu.be/MUSIC_ID_2" \
  "https://youtu.be/MUSIC_ID_3"
```

The URLs can be individual videos from completely different playlists or channels.

No YouTube playlist needs to be created.

---

## Download URLs from a Text File

For a larger batch, put one URL per line in a text file:

```text
https://youtu.be/VIDEO_ID_1
https://youtu.be/VIDEO_ID_2
https://youtu.be/VIDEO_ID_3
```

For example, save the file as:

```text
urls.txt
```

Then download all videos:

```bash
yt --batch-file urls.txt
```

Or extract them all as MP3:

```bash
ytmp3 --batch-file urls.txt
```

Comments and blank lines can be used in the batch file where supported by yt-dlp.

---

## Download an Entire Playlist

You can still download an entire YouTube playlist normally:

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

## Mix Individual URLs and Playlists

Because the wrappers pass standard yt-dlp arguments through, you can also provide multiple URLs and playlists in the same command:

```bash
yt \
  "https://youtu.be/VIDEO_ID" \
  "https://www.youtube.com/playlist?list=PLAYLIST_ID"
```

> **Tip:** For a large or frequently reused collection, a batch file is usually easier to maintain than a very long command line.

---

# ⚙️ Advanced Options

### Download URLs from a File

Create a text file containing one URL per line:

```text
https://youtu.be/VIDEO_ID_1
https://youtu.be/VIDEO_ID_2
https://youtu.be/VIDEO_ID_3
```

Then:

```bash
yt --batch-file urls.txt
```

For MP3 extraction:

```bash
ytmp3 --batch-file urls.txt
```

This is useful when downloading a large collection of individual videos or songs without creating a YouTube playlist.

---

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

## Python Version Warnings

If you are using the standalone yt-dlp binary from this README, Python is not required.

If you installed yt-dlp through Python/pip, Python **3.11 or newer** is required for this setup.

Check your version:

```bash
python3 --version
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

## Update the Wrapper Scripts

If you installed them manually from the repository, you can download the latest versions:

```bash
curl -fsSL \
  "https://raw.githubusercontent.com/mmarkus13/yt-dlc/main/yt" \
  -o "$HOME/scripts/yt"

curl -fsSL \
  "https://raw.githubusercontent.com/mmarkus13/yt-dlc/main/ytmp3" \
  -o "$HOME/scripts/ytmp3"

chmod +x "$HOME/scripts/yt" "$HOME/scripts/ytmp3"
```

If you cloned the repository:

```bash
cd "$HOME/yt-dlc"
git pull
```

Then copy the updated wrappers:

```bash
cp yt ytmp3 "$HOME/scripts/"
chmod +x "$HOME/scripts/yt" "$HOME/scripts/ytmp3"
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

---

# 🎮 SteamOS Notes

This setup can also be used on SteamOS.

SteamOS is Arch Linux-based, but its system filesystem and package-management behavior can differ from a conventional Arch installation.

The standalone yt-dlp binary does not require Python.

Deno can be installed using the official installer.

FFmpeg is required for video merging and audio conversion.

Check whether FFmpeg is already available:

```bash
ffmpeg -version
```

If it is missing, follow the current SteamOS-specific instructions for installing packages appropriate to your SteamOS version.

> SteamOS updates may reset or alter parts of the system environment. Keeping user-installed tools under `$HOME` is generally preferable where practical.

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

The wrappers normally save downloads according to yt-dlp's default output behavior.

If you want a fixed output directory, edit the `yt` or `ytmp3` wrapper and modify its yt-dlp output template.

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

# 🧪 Testing

Verify that the installed commands are available:

```bash
which yt
which ytmp3
```

Then test the video wrapper:

```bash
yt "https://youtu.be/VIDEO_ID"
```

And the audio wrapper:

```bash
ytmp3 "https://youtu.be/MUSIC_ID"
```

---

# 📌 Important Notes

- Keep yt-dlp updated because YouTube changes frequently.
- Keep Deno updated and use a currently supported version.
- FFmpeg is required for many video/audio processing operations.
- The official standalone yt-dlp binary does not require Python.
- Python **3.11 or newer** is required if you choose the PyPI/Python installation method.
- A separate `pip install yt-dlp-ejs` is not required for the standalone-binary setup.
- The `yt` and `ytmp3` wrapper scripts are maintained as files in this repository.
- The installer downloads the repository versions of `yt` and `ytmp3`, avoiding duplicated wrapper implementations.
- Avoid relying on permanently hard-coded YouTube client workarounds.
- Only download content you have the right to download and use.

---

**Happy downloading! 🎵**

*Last tested: August 2026 · yt-dlp `2026.07.04` · Deno `2.9.5`*
````
