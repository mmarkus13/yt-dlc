# 🎵 yt-dlc

A lightweight Bash wrapper around [yt-dlp](https://github.com/yt-dlp/yt-dlp) for downloading YouTube videos and extracting audio as MP3.

The project provides two simple commands:

```text
yt
ytmp3
```

Both commands use a shared wrapper:

```text
yt-dlp-wrapper
```

The wrapper adds persistent configuration, separate video/music destinations, transcript downloading, temporary-file handling, and an automatic YouTube extraction fallback while retaining normal yt-dlp command-line functionality.

---

## 🚀 Quick Install

> Install everything with a single command block:

```bash
mkdir -p ~/scripts && cd ~/scripts && \
curl -fsSL "https://raw.githubusercontent.com/mmarkus13/yt-dlc/main/installer.sh" \
  -o installer.sh && \
chmod +x installer.sh && \
./installer.sh
```

The installer will:

- Create `~/scripts`
- Add `~/scripts` to your shell `PATH`
- Install Deno if it is not already installed
- Download the latest official standalone yt-dlp binary to `~/.local/bin/yt-dlp`
- Check for FFmpeg
- Ask whether FFmpeg should be installed if it is missing
- Download the version-controlled `yt`, `ytmp3`, and `yt-dlp-wrapper` scripts
- Configure the appropriate shell startup file
- Verify the installed components

The actual `yt-dlp` executable is kept in `~/.local/bin` rather than `~/scripts`.

The `~/scripts` directory is reserved for the user-facing commands and wrapper scripts.

After installation, reload your current shell once:

```bash
source ~/.bashrc
```

If you use Zsh instead:

```bash
source ~/.zshrc
```

You can then run `yt` and `ytmp3` from any directory:

```bash
yt "https://youtu.be/VIDEO_ID"
ytmp3 "https://youtu.be/MUSIC_ID"
```

> 💡 WSL: The same Bash commands work on Windows 10 and 11 through [Windows Subsystem for Linux (WSL)](https://learn.microsoft.com/windows/wsl/).

> 💡 SteamOS: This setup can also be used on SteamOS. \
> The installer detects SteamOS and handles FFmpeg installation separately because SteamOS uses a read-only system filesystem by default.

---

## ✨ Features

Feature  | Description
--- | ---
Video Download  | Downloads the best available video/audio and produces an MP4 when possible
Audio Extraction  | Extracts the best available audio and converts it to MP3 with FFmpeg
Transcript Download | Optionally downloads available subtitles/transcripts for both video and MP3 downloads
Transcript Fallback | Tries the configured subtitle language first, then attempts another available subtitle language
Independent Transcript Download | Can download a missing transcript even when the media file already exists
Interactive Configuration | Configure download directories, transcripts, overwrite behavior, delay, and geo-country interactively
Configuration Display | Show the current wrapper configuration with `--show-config`
Batch Downloads  | Download multiple individual URLs without creating a playlist
Batch Files  | Pass a text file containing multiple URLs directly to yt-dlp
Playlists  | Download individual videos or entire YouTube playlists
Mixed Inputs  | Combine individual URLs, playlists, and yt-dlp options
Automatic Fallback  | Retries failed extraction using YouTube's `web` player client
Resume Support  | Interrupted downloads can be retried
WSL-Friendly Temporary Files | Performs temporary download/merge work on the Linux filesystem instead of `/mnt/c`
Cross-Platform  | Designed for Linux, macOS, WSL, and SteamOS
Minimal Setup  | Uses the official standalone yt-dlp binary
Customizable  | Standard yt-dlp options can be passed through the wrappers
CLI Workflow  | Designed for scripting, automation, and terminal use

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

Python is **not required** for the normal installation described by this project.

This project uses the official standalone yt-dlp binary, which does not require a system Python installation.

If you instead choose to install yt-dlp through PyPI, use **Python 3.11 or newer**.

For example:

```bash
python3 --version
```

Then:

```bash
python3 -m pip install -U "yt-dlp[default]"
```

The `default` dependency group includes the appropriate yt-dlp EJS package for the PyPI installation.

> **Note:** Python 3.10 is not supported by this project's documented PyPI installation path. Use Python 3.11 or newer.

### Why Deno?

yt-dlp uses JavaScript challenge-solving components for some YouTube extraction operations.

The official standalone yt-dlp executable used by this project already contains the required EJS components.

A supported external JavaScript runtime is still required to execute those components.

Deno is the recommended JavaScript runtime for yt-dlp's YouTube support.

Therefore:

```text
yt-dlp standalone binary
        │
        ├── bundled EJS components
        │
        └── external JavaScript runtime
                    │
                    └── Deno
```

This project does **not** separately install `yt-dlp-ejs` when using the official standalone yt-dlp binary.

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

Verify:

```bash
deno --version
```

If you use Zsh instead of Bash, add the environment variables to `~/.zshrc` instead.

---

## 3. Install yt-dlp

Download the official standalone yt-dlp binary:

```bash
mkdir -p "$HOME/.local/bin"

curl -fsSL \
  "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp" \
  -o "$HOME/.local/bin/yt-dlp"
```

Make it executable:

```bash
chmod +x "$HOME/.local/bin/yt-dlp"
```

Verify:

```bash
"$HOME/.local/bin/yt-dlp" --version
```

The standalone binary does not require Python.

> The wrapper calls `~/.local/bin/yt-dlp` explicitly. Keeping the executable here separates the third-party downloader from the personal scripts in `~/scripts`.

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

SteamOS is Arch Linux-based, but its system filesystem and package-management behavior differ from a conventional Arch installation.

Check whether FFmpeg is already available:

```bash
ffmpeg -version
```

If it is missing, SteamOS package installation may require temporarily disabling the read-only filesystem.

The installer handles this separately when possible.

> **Important:** Packages installed into the SteamOS system filesystem may be affected by future SteamOS updates. Keep this in mind when using system-level package installation.

---

## 5. Install the Wrapper Scripts

The repository contains three version-controlled scripts:

```text
yt
ytmp3
yt-dlp-wrapper
```

`yt` and `ytmp3` are the user-facing commands.

`yt-dlp-wrapper` contains the shared implementation used by both commands.

These files are the single source of truth for the wrapper implementation.

### Option A — Clone the Repository

Clone the repository:

```bash
git clone \
  "https://github.com/mmarkus13/yt-dlc.git" \
  "$HOME/yt-dlc"
```

Copy the wrapper scripts:

```bash
cp "$HOME/yt-dlc/yt" \
   "$HOME/yt-dlc/ytmp3" \
   "$HOME/yt-dlc/yt-dlp-wrapper" \
   "$HOME/scripts/"
```

Make them executable:

```bash
chmod +x \
  "$HOME/scripts/yt" \
  "$HOME/scripts/ytmp3" \
  "$HOME/scripts/yt-dlp-wrapper"
```

### Option B — Download the Wrapper Scripts Directly

If you don't want to clone the repository:

```bash
curl -fsSL \
  "https://raw.githubusercontent.com/mmarkus13/yt-dlc/main/yt" \
  -o "$HOME/scripts/yt"

curl -fsSL \
  "https://raw.githubusercontent.com/mmarkus13/yt-dlc/main/ytmp3" \
  -o "$HOME/scripts/ytmp3"

curl -fsSL \
  "https://raw.githubusercontent.com/mmarkus13/yt-dlc/main/yt-dlp-wrapper" \
  -o "$HOME/scripts/yt-dlp-wrapper"

chmod +x \
  "$HOME/scripts/yt" \
  "$HOME/scripts/ytmp3" \
  "$HOME/scripts/yt-dlp-wrapper"
```

This installs only the wrapper scripts.

You must still install yt-dlp, Deno, FFmpeg, and configure `~/scripts` in your `PATH` separately.

---

## 6. Add `~/scripts` to Your PATH

The user-facing wrapper commands live in `~/scripts`.

For Bash:

```bash
echo 'export PATH="$HOME/scripts:$PATH"' >> "$HOME/.bashrc"
source "$HOME/.bashrc"
```

`~/.local/bin` is normally already included in the PATH on standard Linux installations. If it is not, add it:

```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
source "$HOME/.bashrc"
```

Verify:

```bash
command -v yt
command -v ytmp3
command -v yt-dlp
```

You should see paths similar to:

```text
/home/yourname/scripts/yt
/home/yourname/scripts/ytmp3
/home/yourname/.local/bin/yt-dlp
```

> If a PATH entry already exists, do not add it again.

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

Then:

```bash
yt --batch-file urls.txt
```

Or:

```bash
ytmp3 --batch-file urls.txt
```

Comments and blank lines can be used in batch files where supported by yt-dlp.

---

## Download into a Specific Directory

The recommended way to permanently configure output directories is:

```bash
yt --configure
```

For a one-off download, you can also change to the desired directory before running the wrapper:

```bash
cd "$HOME/Downloads"
yt "https://youtu.be/VIDEO_ID"
```

For music:

```bash
cd "$HOME/Music"
ytmp3 "https://youtu.be/MUSIC_ID"
```

The persistent configuration described in the [Configuration](#configuration) section takes precedence for normal wrapper downloads.

---

# ⚙️ Configuration

The wrapper stores its persistent configuration in:

```text
~/.config/yt-dlc/config
```

The configuration directory and file are created automatically when needed.

### Show Current Configuration

Run:

```bash
yt --show-config
```

The same command works through `ytmp3`:

```bash
ytmp3 --show-config
```

Example:

```text
Current download preferences
-----------------------------
  Video directory:        /path/to/videos
  Music directory:        /path/to/music
  Transcripts:             Yes (en)
  Overwrite files:         No
  Download delay:          0s
  Geo country:             Not specified
  Temporary files:         /home/yourname/.cache/yt-dlc/tmp
```

`--show-config` is a wrapper command. It is handled before anything is passed to yt-dlp.

### Interactive Configuration

Run:

```bash
yt --configure
```

The configuration wizard can set:

- Video download directory
- Music download directory
- Whether transcripts should be downloaded
- Preferred transcript language
- Whether existing files may be overwritten
- Download delay
- Geo-country preference

The resulting configuration is stored in:

```text
~/.config/yt-dlc/config
```

There is no need to create the directory manually.

### Configuration File

A typical configuration looks like:

```bash
VIDEO_DIR=/path/to/videos
MUSIC_DIR=/path/to/music

TRANSCRIPTS=yes
TRANSCRIPT_LANG=en

OVERWRITE=no
DOWNLOAD_DELAY=''
GEO_COUNTRY=''
```

The wrapper loads this configuration for every download.

---

# 📝 Transcripts

Transcript downloading is controlled by:

```text
TRANSCRIPTS
TRANSCRIPT_LANG
```

For example:

```bash
TRANSCRIPTS=yes
TRANSCRIPT_LANG=en
```

When transcripts are enabled, both `yt` and `ytmp3` attempt to download available subtitles/transcripts.

The wrapper uses this order:

1. Try the configured language.
2. If that language is unavailable, try another available subtitle language.
3. If no subtitle can be downloaded, continue without failing the media download.

If successful, the transcript is saved as a `.vtt` file next to the downloaded media.

For example:

```text
Video Title [VIDEO_ID].mp4
Video Title [VIDEO_ID].en.vtt
```

The transcript download is independent of the media download.

For example, if the media file already exists but the transcript does not, running:

```bash
yt "https://youtu.be/VIDEO_ID"
```

can reuse the existing media file and still download the missing transcript.

The same behavior applies to:

```bash
ytmp3 "https://youtu.be/MUSIC_ID"
```

If no transcript is available, the media download is still considered successful and the wrapper reports:

```text
ℹ️ No transcript was downloaded.
```

> `ytmp3` does not disable transcripts. \
> This allows audio downloads to be accompanied by available subtitles when the source provides them.

---

# 📚 Multiple Videos, Songs & Playlists

You don't need to create a YouTube playlist to download multiple items.

The wrappers pass standard yt-dlp arguments through to the downloader.

## Multiple Individual Videos

```bash
yt \
  "https://youtu.be/VIDEO_ID_1" \
  "https://youtu.be/VIDEO_ID_2" \
  "https://youtu.be/VIDEO_ID_3"
```

## Multiple Songs as MP3

```bash
ytmp3 \
  "https://youtu.be/MUSIC_ID_1" \
  "https://youtu.be/MUSIC_ID_2" \
  "https://youtu.be/MUSIC_ID_3"
```

The URLs can belong to completely different playlists or channels.

No YouTube playlist needs to be created.

---

## Download an Entire Playlist

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

You can combine individual URLs and playlists:

```bash
yt \
  "https://youtu.be/VIDEO_ID" \
  "https://www.youtube.com/playlist?list=PLAYLIST_ID"
```

For a large collection, a batch file is usually easier to maintain.

---

# 🔄 Automatic Extraction Fallback

The wrappers first allow yt-dlp to use its normal/default YouTube client selection.

If extraction fails, the wrapper automatically retries using:

```bash
--extractor-args "youtube:player_client=web"
```

This is intentional.

YouTube's client behavior changes over time, and forcing `web` for every download can unnecessarily override yt-dlp's normal client selection.

The fallback gives the downloader a second extraction configuration without permanently forcing `web`.

You may see:

```text
Normal extraction failed; retrying with YouTube web client...
```

when the fallback is triggered.

> The fallback cannot fix every failure. Authentication requirements, unavailable videos, network errors, regional restrictions, or other failures may still prevent a download.

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

After installation, your home directory can look like this:

```text
~
├── scripts/
│   ├── yt
│   ├── ytmp3
│   └── yt-dlp-wrapper
│
├── .local/
│   └── bin/
│       └── yt-dlp
│
├── .config/
│   └── yt-dlc/
│       └── config
│
├── .cache/
│   └── yt-dlc/
│       └── tmp/
│
└── yt-dlc/
    ├── README.md
    ├── installer.sh
    ├── yt
    ├── ytmp3
    ├── yt-dlp-wrapper
    └── uninstall.sh
```

The repository directory is the project/source directory.

The installed user-facing commands live in:

```text
~/scripts/
```

The standalone yt-dlp executable lives in:

```text
~/.local/bin/
```

Persistent configuration lives in:

```text
~/.config/yt-dlc/
```

Temporary download files live in:

```text
~/.cache/yt-dlc/tmp/
```

Downloaded media is stored separately according to the configured video and music directories.

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
/home/yourname/.deno/bin
```

in the PATH.

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

Also check which binary is being used:

```bash
which yt-dlp
```

The official standalone yt-dlp binary used by this project already contains the required EJS components.

Deno is used as the external JavaScript runtime.

---

## `no such option: --js-runtimes`

Your yt-dlp version is probably too old.

Update it:

```bash
yt-dlp -U
```

Or explicitly:

```bash
"$HOME/.local/bin/yt-dlp" -U
```

Then:

```bash
yt-dlp --version
```

Check which executable is being used:

```bash
command -v yt-dlp
```

It should normally point to:

```text
/home/yourname/.local/bin/yt-dlp
```

---

## `HTTP Error 403: Forbidden`

First update yt-dlp:

```bash
yt-dlp -U
```

Then check:

```bash
deno --version
ffmpeg -version
```

The wrapper will automatically retry using the YouTube `web` player client after a normal extraction failure.

Avoid permanently adding additional client workarounds unless there is a current, reproducible reason to do so.

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

Python is not required when using the standalone yt-dlp binary installed by this project.

If you choose the PyPI/Python installation method, use Python **3.11 or newer**.

Check:

```bash
python3 --version
```

Then:

```bash
python3 -m pip install -U "yt-dlp[default]"
```

---

## FFmpeg Is Missing

Check:

```bash
ffmpeg -version
```

If FFmpeg is unavailable, video merging and MP3 extraction may fail.

On Debian/Ubuntu/WSL:

```bash
sudo apt update
sudo apt install -y ffmpeg
```

On macOS with Homebrew:

```bash
brew install ffmpeg
```

On SteamOS, see the [SteamOS Notes](#-steamos-notes) section.

---

# 🧹 Cleaning Partial Downloads

The wrapper uses:

```text
~/.cache/yt-dlc/tmp
```

for temporary download and processing files.

To inspect the temporary directory:

```bash
find "$HOME/.cache/yt-dlc/tmp" -type f -print
```

To find partial yt-dlp files there:

```bash
find "$HOME/.cache/yt-dlc/tmp" -type f \( \
  -name "*.part" \
  -o -name "*.part-Frag*" \
  -o -name "*.ytdl" \
\) -print
```

If necessary, remove them:

```bash
find "$HOME/.cache/yt-dlc/tmp" -type f \( \
  -name "*.part" \
  -o -name "*.part-Frag*" \
  -o -name "*.ytdl" \
\) -delete
```

Normally this should not be necessary after a successful download because yt-dlp cleans up its temporary working files.

> Review the files first if you have an interrupted download that you intend to resume.

---

# ✅ Verify the Installation

Run:

```bash
yt-dlp --version
deno --version
ffmpeg -version
command -v yt
command -v ytmp3
command -v yt-dlp
```

Then display the wrapper configuration:

```bash
yt --show-config
```

Test the configuration wizard:

```bash
yt --configure
```

Then test a video:

```bash
yt "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
```

And test audio extraction:

```bash
ytmp3 "https://www.youtube.com/watch?v=BaW_jOozKJk"
```

If transcripts are enabled, verify that a `.vtt` transcript is created alongside the downloaded media.

Also verify that:

```text
~/.cache/yt-dlc/tmp
```

is used for temporary processing rather than the final Windows-mounted destination.

Test an existing media file with a missing transcript to verify that the transcript can still be downloaded independently.

---

# 🔄 Updating

## Update yt-dlp

Because you're using the standalone binary:

```bash
yt-dlp -U
```

Or explicitly:

```bash
"$HOME/.local/bin/yt-dlp" -U
```

Verify:

```bash
yt-dlp --version
```

Keeping yt-dlp updated is particularly important because YouTube changes frequently.

---

## Update Deno

```bash
deno upgrade
```

Verify:

```bash
deno --version
```

---

## Update the Wrapper Scripts

If you installed them manually from the repository:

```bash
curl -fsSL \
  "https://raw.githubusercontent.com/mmarkus13/yt-dlc/main/yt" \
  -o "$HOME/scripts/yt"

curl -fsSL \
  "https://raw.githubusercontent.com/mmarkus13/yt-dlc/main/ytmp3" \
  -o "$HOME/scripts/ytmp3"

curl -fsSL \
  "https://raw.githubusercontent.com/mmarkus13/yt-dlc/main/yt-dlp-wrapper" \
  -o "$HOME/scripts/yt-dlp-wrapper"

chmod +x \
  "$HOME/scripts/yt" \
  "$HOME/scripts/ytmp3" \
  "$HOME/scripts/yt-dlp-wrapper"
```

If you cloned the repository:

```bash
cd "$HOME/yt-dlc"
git pull
```

Then:

```bash
cp \
  yt \
  ytmp3 \
  yt-dlp-wrapper \
  "$HOME/scripts/"

chmod +x \
  "$HOME/scripts/yt" \
  "$HOME/scripts/ytmp3" \
  "$HOME/scripts/yt-dlp-wrapper"
```

Your personal configuration in:

```text
~/.config/yt-dlc/config
```

is not replaced by updating the wrapper scripts.

---

# 📦 Temporary Download Files

The wrapper uses:

```text
~/.cache/yt-dlc/tmp
```

for temporary download and processing files.

The directory is created automatically when needed.

### Why use the Linux filesystem?

When running under WSL, downloading temporary files directly to `/mnt/c` can cause filesystem-related problems during operations such as renaming `.part` files or merging separate audio/video streams.

The wrapper therefore performs temporary work under the native Linux filesystem:

```text
/home/yourname/.cache/yt-dlc/tmp
```

After processing is complete, the finished media and transcript files are moved to their configured destinations, which may be on the Windows filesystem.

For example:

```text
YouTube
   ↓
~/.cache/yt-dlc/tmp
   ↓
configured video/music directory
```

yt-dlp normally removes its temporary working files after successful operations.

The parent cache directory may remain and does not need to be manually removed.

This directory is also removed by the project's `uninstall.sh` script.

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

### Temporary Files Under WSL

The wrapper intentionally keeps temporary download and processing files inside the Linux filesystem:

```text
~/.cache/yt-dlc/tmp
```

rather than under `/mnt/c`.

This avoids common WSL filesystem issues during downloads, renames, merging, and conversion.

The final files can still be stored on a Windows drive, for example:

```text
/mnt/c/Users/YourName/Videos
/mnt/c/Users/YourName/Music
```

The wrapper moves completed files to their configured destinations after processing.

---

# 🎮 SteamOS Notes

This setup can also be used on SteamOS.

SteamOS is Arch Linux-based, but it is not simply a conventional Arch installation. Its system filesystem is normally read-only.

The standalone yt-dlp binary does not require Python.

Deno can be installed using the official installer.

FFmpeg is required for video merging and audio conversion.

Check whether FFmpeg is already available:

```bash
ffmpeg -version
```

If it is missing, the installer can ask whether you want it installed.

The installer handles SteamOS separately and temporarily disables the read-only filesystem when package installation is required.

> **Important:** System packages installed directly into the SteamOS root filesystem may be affected by future SteamOS updates.
> User files under `$HOME` are preferable for persistent project files and scripts.

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

## Change the Default Output Directories

The wrapper supports separate persistent output directories for video and music.

Run:

```bash
yt --configure
```

The configuration wizard can set:

- Video download directory
- Music download directory
- Whether transcripts should be downloaded
- Preferred transcript language
- Whether existing files may be overwritten
- Download delay
- Geo-country preference

The configuration is stored in:

```text
~/.config/yt-dlc/config
```

For example:

```bash
VIDEO_DIR=/mnt/c/Users/YourName/Videos/YT-dlg
MUSIC_DIR=/mnt/c/Users/YourName/Music
```

After configuration:

```bash
yt "https://youtu.be/VIDEO_ID"
```

downloads video to the configured video directory.

Likewise:

```bash
ytmp3 "https://youtu.be/MUSIC_ID"
```

downloads audio to the configured music directory.

The configured destinations are independent of the current working directory.

You can inspect the current settings at any time:

```bash
yt --show-config
```

The same command is available through `ytmp3`:

```bash
ytmp3 --show-config
```

The wrapper's persistent configuration controls its normal default behavior. Standard yt-dlp command-line options can still be passed for individual downloads where appropriate.

---

# 🗑️ Uninstall

The project includes an `uninstall.sh` script that removes the files installed by this project.

Run:

```bash
"$HOME/scripts/uninstall.sh"
```

The uninstaller removes:

```text
~/scripts/yt
~/scripts/ytmp3
~/scripts/yt-dlp-wrapper
~/scripts/uninstall.sh
~/.local/bin/yt-dlp
~/.config/yt-dlc/
~/.cache/yt-dlc/
```

It asks for confirmation before removing anything.

Downloaded videos and music are **not** removed.

The uninstaller does not remove:

- `~/scripts` itself
- `~/.local/bin` itself
- `~/.config` itself
- `~/.cache` itself
- Any downloaded media
- Other unrelated scripts or files

---

# 📜 License

This project consists primarily of wrapper scripts around third-party software.

- **[yt-dlp](https://github.com/yt-dlp/yt-dlp)** — Unlicense
- **[Deno](https://deno.com/)** — MIT
- **[yt-dlp-ejs](https://github.com/yt-dlp/ejs)** — MIT

The project does not separately install `yt-dlp-ejs` when using the official standalone yt-dlp binary.

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
command -v yt
command -v ytmp3
command -v yt-dlp
command -v deno
command -v ffmpeg
```

Expected locations include:

```text
~/scripts/yt
~/scripts/ytmp3
~/.local/bin/yt-dlp
```

Check the wrapper syntax:

```bash
bash -n "$HOME/scripts/yt-dlp-wrapper"
bash -n "$HOME/scripts/yt"
bash -n "$HOME/scripts/ytmp3"
```

A successful syntax check produces no output.

Display the configuration:

```bash
yt --show-config
```

Test the configuration wizard:

```bash
yt --configure
```

Test a video:

```bash
yt "https://youtu.be/VIDEO_ID"
```

Test audio extraction:

```bash
ytmp3 "https://youtu.be/MUSIC_ID"
```

If transcripts are enabled, verify that a `.vtt` transcript is created alongside the downloaded media.

Also verify that:

```text
~/.cache/yt-dlc/tmp
```

is used for temporary processing rather than the final Windows-mounted destination.

Test an existing media file with a missing transcript to verify that the transcript can still be downloaded independently.

---

# 📌 Important Notes

- Keep yt-dlp updated because YouTube changes frequently.
- Keep Deno updated and use a currently supported version.
- FFmpeg is required for many video/audio processing operations.
- The official standalone yt-dlp binary does not require Python.
- Python 3.11 or newer is recommended for the optional PyPI installation path used by this project.
- Python 3.10 is not used or required by the normal installation.
- A separate `pip install yt-dlp-ejs` is not required for the standalone-binary setup.
- The actual yt-dlp executable is installed in `~/.local/bin/yt-dlp`.
- The `yt`, `ytmp3`, and `yt-dlp-wrapper` scripts are maintained in this repository.
- `~/scripts` contains the user-facing commands and wrapper scripts, not the yt-dlp executable itself.
- Persistent wrapper configuration is stored in `~/.config/yt-dlc/config`.
- Temporary download and processing files are stored in `~/.cache/yt-dlc/tmp`.
- Temporary files are kept on the Linux filesystem under WSL to avoid `/mnt/c` filesystem issues.
- Transcript downloading can be enabled independently of the selected media mode.
- The configured transcript language is attempted first, followed by an available subtitle fallback.
- A missing transcript does not cause an otherwise successful media download to fail.
- The wrappers first use yt-dlp's normal client selection and retry with `player_client=web` when extraction fails.
- The wrapper does not use the obsolete `YOUTUBE_DOWNLOAD_PATH` environment variable.
- Output directories are configured through `VIDEO_DIR` and `MUSIC_DIR` using `yt --configure`.
- Avoid relying on permanently hard-coded YouTube client workarounds.
- Only download content you have the right to download and use.

---

**Happy downloading! 🎵**

*Last tested: August 2026 · yt-dlp `2026.07.04` · Deno `2.9.5`*
