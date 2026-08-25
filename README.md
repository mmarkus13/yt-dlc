# 🎵 YouTube Downloader CLI

A lightweight command-line YouTube downloader built around
[yt-dlp](https://github.com/yt-dlp/yt-dlp), Deno, and FFmpeg.

No GUI bloat, no complicated configuration — just a small set of wrapper
scripts for downloading video and audio from the command line.

> Status: Tested in August 2026 with yt-dlp `2026.08.19` and Deno `2.9.5`.

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
- Download the latest official standalone yt-dlp binary
- Check for FFmpeg
- Ask whether FFmpeg should be installed if it is missing
- Download the version-controlled `yt` and `ytmp3` wrapper scripts
- Configure the appropriate shell startup file
- Verify the installed components

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
yt dQw4w9WgXcQ
ytmp3 xYTeFnQ_lCU
```

> 💡 **WSL:** The same Bash commands work on Windows 10 and 11 through
> [Windows Subsystem for Linux (WSL)](https://learn.microsoft.com/en-us/windows/wsl/).

> 💡 **SteamOS:** This setup can also be used on SteamOS.\
The installer detects SteamOS and handles FFmpeg installation separately because
SteamOS uses a read-only system filesystem by default.

---

## ✨ Features

| Feature | Description |
| --- | --- |
| Video Download | Downloads the best available video/audio and produces an MP4 when possible |
| Audio Extraction | Extracts the best available audio and converts it to MP3 with FFmpeg |
| Forgiving Input | Accepts video IDs, shortened URLs, and full YouTube URLs |
| Batch Downloads | Download multiple individual videos in one command |
| Flexible Separators | Separate inputs with spaces, commas, or semicolons |
| Automatic Fallback | Retries failed extraction using YouTube's `web` player client |
| Error Handling | Optionally continue processing after individual failures |
| Resume Support | Interrupted downloads can be retried |
| Cross-Platform | Designed for Linux, macOS, WSL, and SteamOS |
| Minimal Setup | Uses the official standalone yt-dlp binary |
| Configuration | Interactive wrapper configuration is available through `--configure` |
| CLI Workflow | Designed for scripting, automation, and terminal use |

---

# 🎯 Why This Instead of Tartube?

| Feature | This Setup | Tartube |
| --- | --- | --- |
| Installation | ~5 minutes | More involved |
| Interface | CLI | GUI |
| Dependencies | yt-dlp, Deno, FFmpeg | GUI and backend dependencies |
| Flexibility | Lightweight wrapper around yt-dlp | GUI-oriented |
| Resource Usage | Very lightweight | Higher |
| Maintenance | A few scripts + yt-dlp | Multiple application components |
| Automation | Excellent | More GUI-oriented |

This project is intended for users who prefer a terminal-based workflow with a
small, predictable wrapper around yt-dlp.

---

# 📋 Prerequisites

### Required

| Component | Recommended | Purpose |
| --- | --- | --- |
| yt-dlp | Latest stable release | YouTube downloader |
| Deno | Current supported version | JavaScript runtime used by yt-dlp for YouTube |
| FFmpeg | Current stable version | Video merging and audio conversion |

The automated installer handles these dependencies where possible.

### Python

Python is not required for the normal installation described by this project.

This project uses the official standalone yt-dlp binary, which does not require
a system Python installation.

If you instead choose to install yt-dlp through PyPI, use Python 3.11 or newer.

For example:

```bash
python3 --version
```

Then:

```bash
python3 -m pip install -U "yt-dlp[default]"
```

The `default` dependency group includes the appropriate `yt-dlp-ejs` package
for the PyPI installation.

> **Note:** Python 3.10 is not supported by this project's documented PyPI
> installation path. Use Python 3.11 or newer.

### Why Deno?

yt-dlp uses an external JavaScript runtime to solve JavaScript challenges
required for full YouTube extraction.

Deno is the recommended JavaScript runtime for yt-dlp's YouTube support.

The official standalone yt-dlp executables already contain the required EJS
components, so this project does not separately install `yt-dlp-ejs`.

---

# 🔧 Detailed / Manual Setup

> Prefer the easy way?\
> Use the [Quick Install](#-quick-install) section at the top of this README.

This section is provided for transparency and for users who prefer to install and configure each component manually.

These instructions target Linux, macOS, WSL, and SteamOS where the required
tools can be installed normally.

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

If you use Zsh instead of Bash, add the environment variables to `~/.zshrc`
instead.

---

## 3. Install yt-dlp

Download the official standalone yt-dlp binary:

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

The standalone binary does not require Python.

---

## 4. Install FFmpeg

FFmpeg is strongly recommended because yt-dlp often needs it to merge separate
video/audio streams and convert audio.

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

SteamOS is Arch Linux-based, but its system filesystem and package-management
behavior differ from a conventional Arch installation.

Check whether FFmpeg is already available:

```bash
ffmpeg -version
```

If it is missing, SteamOS package installation may require temporarily
disabling the read-only filesystem.

The installer handles this automatically when possible.

> **Important:** Packages installed into the SteamOS system filesystem may be
> affected by future SteamOS updates. Keep this in mind when using system-level
> package installation.

---

## 5. Install the Wrapper Scripts

The repository contains two version-controlled wrapper scripts:

```text
yt
ytmp3
```

These files are the single source of truth for the wrapper implementations.

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

If you don't want to clone the repository:

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

You must still install yt-dlp, Deno, FFmpeg, and configure `~/scripts` in your
`PATH` separately.

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

The simplest form is to provide the YouTube video ID:

```bash
yt dQw4w9WgXcQ
```

A shortened URL also works:

```bash
yt youtu.be/dQw4w9WgXcQ
```

A complete URL works as well:

```bash
yt https://youtu.be/dQw4w9WgXcQ
```

You can also use a normal YouTube URL:

```bash
yt https://www.youtube.com/watch?v=dQw4w9WgXcQ
```

The wrapper normalizes these forms before passing the URL to yt-dlp.

---

## Download Audio as MP3

Use `ytmp3` instead:

```bash
ytmp3 xYTeFnQ_lCU
```

For example:

```bash
cd "$HOME/Music"
ytmp3 xYTeFnQ_lCU
```

---

## Download Multiple Individual URLs

Multiple video IDs or URLs can be supplied directly:

```bash
yt dQw4w9WgXcQ xYTeFnQ_lCU
```

You can mix input styles:

```bash
yt dQw4w9WgXcQ youtu.be/xYTeFnQ_lCU
```

Full URLs are supported too:

```bash
yt \
  "https://youtu.be/dQw4w9WgXcQ" \
  "https://youtu.be/xYTeFnQ_lCU"
```

For audio:

```bash
ytmp3 dQw4w9WgXcQ xYTeFnQ_lCU
```

---

## Flexible Input Separators

Inputs may also be separated by commas:

```bash
yt dQw4w9WgXcQ,xYTeFnQ_lCU
```

Or semicolons:

```bash
yt 'dQw4w9WgXcQ;xYTeFnQ_lCU'
```

Spaces, commas, and semicolons can be mixed:

```bash
yt 'dQw4w9WgXcQ, xYTeFnQ_lCU; dQw4w9WgXcQ'
```

> 💡 **Shell note:** Semicolons have a special meaning to most shells.\
Quote an argument containing `;` so that the shell passes it to the wrapper instead of treating it as a command separator.

The same syntax works with `ytmp3`:

```bash
ytmp3 'dQw4w9WgXcQ;xYTeFnQ_lCU'
```

---

## How Arguments Are Interpreted

The wrapper uses a deliberately simple rule:

- Arguments beginning with `--` are interpreted as wrapper options.
- Everything else is treated as a video/audio input.
- Unknown `--` options are rejected.
- Multiple non-option arguments are accepted as separate inputs.
- Commas and semicolons inside input arguments are treated as separators.

For example:

```bash
yt --ignore-errors dQw4w9WgXcQ xYTeFnQ_lCU
```

Here `--ignore-errors` is an option and both video IDs are inputs.

An unknown option is rejected rather than accidentally being interpreted as a
URL:

```bash
yt dQw4w9WgXcQ --WhatIfIGiveYouSomethingThatDoesNotWork
```

This produces an error instead of passing an unexpected argument downstream.

---

## Download into a Specific Directory

Change directories before running the command:

```bash
cd "$HOME/Downloads"
yt dQw4w9WgXcQ
```

For music:

```bash
cd "$HOME/Music"
ytmp3 xYTeFnQ_lCU
```

- Output directories are stored in `~/.config/yt-dlc/config` and can be configured with `yt --configure`.
- Video downloads use `VIDEO_DIR`, while audio downloads use `MUSIC_DIR`.

---

# 📚 Multiple Videos & Batch Downloads

You don't need to create a YouTube playlist to download multiple individual
videos.

The wrapper accepts multiple IDs or URLs directly:

```bash
yt \
  dQw4w9WgXcQ \
  xYTeFnQ_lCU \
  another_video_id
```

Or in a single quoted argument:

```bash
yt 'dQw4w9WgXcQ;xYTeFnQ_lCU;another_video_id'
```

For MP3 downloads:

```bash
ytmp3 \
  dQw4w9WgXcQ \
  xYTeFnQ_lCU \
  another_video_id
```

Each input is processed independently.

If one input fails, the wrapper reports the failure and continues only when
`--ignore-errors` has been specified.

---

## Ignore Individual Download Errors

Use:

```bash
yt --ignore-errors \
  dQw4w9WgXcQ \
  xYTeFnQ_lCU
```

With this option enabled, a failed input does not stop the remaining inputs
from being processed.

At the end of the batch, the wrapper reports both successful and failed inputs.

Without `--ignore-errors`, a failed download causes the wrapper to stop with an
error.

> 💡 **Important:** `--ignore-errors` does not make an unavailable video
> succeed. It only changes how the wrapper handles the failure.

---

## Download an Entire Playlist

Playlist URLs are passed to yt-dlp as normal inputs:

```bash
yt "https://www.youtube.com/playlist?list=PLAYLIST_ID"
```

> 💡 The wrapper's forgiving input normalization is primarily intended for individual YouTube video URLs and IDs.\
Playlist URLs should be supplied as complete URLs so their query parameters remain intact.

---

## Automatic Extraction Fallback

The wrappers first allow yt-dlp to use its normal/default YouTube client
selection.

If extraction fails, the wrapper automatically retries using:

```text
--extractor-args "youtube:player_client=web"
```

This is intentional.

YouTube's client behavior changes over time, and forcing `web` for every
download can unnecessarily override yt-dlp's normal client selection.

The fallback gives the downloader a second extraction configuration without
permanently forcing `web`.

You may see a retry using the YouTube web client when the normal extraction
fails.

> The fallback cannot fix every failure.\
Authentication requirements, unavailable videos, network errors, regional restrictions, or other failures may still prevent a download.

---

# 🔄 Automatic Extraction Fallback

The wrapper first allows yt-dlp to use its normal/default YouTube client selection.

If extraction fails, the wrapper automatically retries using:

    --extractor-args "youtube:player_client=web"

This is intentional.

YouTube's client behavior changes over time, and forcing `web` for every download can unnecessarily override yt-dlp's normal client selection.

The fallback gives the downloader a second extraction configuration without permanently forcing `web`.

You may see:

    ▶ Retrying with the YouTube web client...

when the fallback is triggered.

The fallback cannot fix every failure.

Authentication requirements, unavailable videos, network errors, regional restrictions, or other failures may still prevent a download.

> 💡 The fallback is a recovery mechanism, not a guarantee that an unavailable video can be downloaded.

---

# ⚙️ Configuration

The wrapper includes a small built-in configuration interface.

Show the current configuration:

    yt --show-config

Configure the wrapper:

    yt --configure

The configuration is intended for wrapper-specific settings rather than exposing the entire yt-dlp command-line interface.

---

# 📁 Recommended Directory Structure

After installation, your home directory can look like this:

    ~
    ├── scripts/
    │   ├── yt
    │   ├── ytmp3
    │   └── yt-dlp
    │
    ├── Videos/YT
    │   └── YouTube downloads
    │
    ├── Music/
    │   └── MP3 downloads
    │
    └── yt-dlc/
        ├── README.md
        ├── installer.sh
        ├── yt
        ├── ytmp3
        └── uninstall.sh

---

# 🧹 Updating / Reinstalling

The installer can be run again when you want to refresh the installed components.

    cd ~/yt-dlc
    ./installer.sh

The installer will check the existing installation and update the relevant components.

If you installed the wrapper manually, update it from the repository:

    cd ~/yt-dlc
    git pull

Then copy the updated wrappers:

    cp yt ytmp3 ~/scripts/

    chmod +x ~/scripts/yt ~/scripts/ytmp3

You can verify the installed versions with:

    yt-dlp --version
    deno --version
    ffmpeg -version

---

# 🛠️ Troubleshooting

## yt: command not found

Check whether `~/scripts` is in your `PATH`:

    echo "$PATH"

If it is missing:

    echo 'export PATH="$HOME/scripts:$PATH"' >> "$HOME/.bashrc"
    source "$HOME/.bashrc"

Then verify:

    which yt

If you use Zsh:

    echo 'export PATH="$HOME/scripts:$PATH"' >> "$HOME/.zshrc"
    source "$HOME/.zshrc"

---

## yt-dlp: command not found

Check that the binary exists:

    ls -l "$HOME/scripts/yt-dlp"

If necessary, reinstall it:

    curl -fsSL \
      "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp" \
      -o "$HOME/scripts/yt-dlp"

    chmod +x "$HOME/scripts/yt-dlp"

Then:

    "$HOME/scripts/yt-dlp" --version

---

## Deno is not found

Check:

    deno --version

If the command is unavailable, verify that Deno's installation directory is in your `PATH`:

    echo "$DENO_INSTALL"
    echo "$PATH"

For a standard installation:

    export DENO_INSTALL="$HOME/.deno"
    export PATH="$DENO_INSTALL/bin:$PATH"

To make this permanent in Bash:

    echo 'export DENO_INSTALL="$HOME/.deno"' >> "$HOME/.bashrc"
    echo 'export PATH="$DENO_INSTALL/bin:$PATH"' >> "$HOME/.bashrc"
    source "$HOME/.bashrc"

---

## FFmpeg is not found

Check:

    ffmpeg -version

If it is missing, install it using your operating system's package manager.

On Debian/Ubuntu/WSL:

    sudo apt update
    sudo apt install -y ffmpeg

On macOS with Homebrew:

    brew install ffmpeg

On SteamOS, use the installer or follow the SteamOS-specific instructions above.

---

## YouTube says the video is unavailable

First, verify the video manually in a browser.

A video may be:

- Deleted
- Private
- Region restricted
- Age restricted
- Members-only
- Unavailable to the current account
- Temporarily unavailable through a particular YouTube client

The wrapper automatically retries failed extraction with the YouTube `web` client, but this cannot bypass access restrictions.

For example:

    ❌ Download failed: https://youtu.be/VIDEO_ID

means that yt-dlp was unable to retrieve the requested video.

This is different from a successful download being skipped because the file already exists.

---

## Downloads work, but JavaScript challenges fail

Make sure Deno is installed and accessible:

    deno --version

Then verify that yt-dlp is current:

    yt-dlp --version

The project uses the official yt-dlp release together with Deno for the JavaScript challenge-solving functionality required by current YouTube extraction.

If the problem persists, update yt-dlp:

    yt --configure

or reinstall the current standalone binary using the installer.

---

## The wrapper reports an unknown option

The wrapper intentionally distinguishes options from URL arguments.

Anything beginning with `--` is interpreted as an option.

For example:

    yt --ignore-errors dQw4w9WgXcQ

Here `--ignore-errors` is an option and `dQw4w9WgXcQ` is a URL.

An unsupported option such as:

    yt --some-unknown-option dQw4w9WgXcQ

will be rejected.

This prevents accidental typos from silently changing downloader behavior.

---

# 🧪 Testing the Installation

After installation, test each component separately.

### Test Deno

    deno --version

### Test FFmpeg

    ffmpeg -version

### Test yt-dlp

    yt-dlp --version

### Test the wrapper

    yt dQw4w9WgXcQ

### Test MP3 extraction

    ytmp3 dQw4w9WgXcQ

### Test multiple arguments

    yt dQw4w9WgXcQ xYTeFnQ_lCU

### Test semicolon-separated input

    yt 'dQw4w9WgXcQ;xYTeFnQ_lCU'

### Test comma-separated input

    yt 'dQw4w9WgXcQ,xYTeFnQ_lCU'

### Test error handling

    yt --ignore-errors dQw4w9WgXcQ xYTeFnQ_lCU

A failed item should not prevent the remaining items from being processed when `--ignore-errors` is enabled.

---

# 🔐 Security Considerations

The installer downloads executable components from the project's GitHub repository and the official yt-dlp release.

For users who want to inspect what will be executed, the installer and wrapper scripts are intentionally kept as ordinary shell scripts and can be reviewed before installation.

You can inspect the installer without executing it:

    curl -fsSL \
      "https://raw.githubusercontent.com/mmarkus13/yt-dlc/main/installer.sh"

Similarly, the wrapper can be inspected directly:

    curl -fsSL \
      "https://raw.githubusercontent.com/mmarkus13/yt-dlc/main/yt"

> 💡 **Automatic updates:** The wrapper may check whether a newer yt-dlp release is available when a download fails. This is deliberately limited to yt-dlp's official release information rather than downloading arbitrary executable content from an untrusted source.

The wrapper does not treat arbitrary positional arguments as shell commands. Arguments beginning with `--` are parsed as wrapper options; all other arguments are treated as URL input.

---

# 🧩 Design Philosophy

This project intentionally keeps the wrapper small.

The goal is not to replace yt-dlp.

Instead, it provides a convenient command-line layer around yt-dlp that handles the few things that are useful in everyday usage:

- Sensible defaults
- Deno availability
- FFmpeg availability
- Automatic fallback extraction
- MP4 video downloads
- MP3 audio extraction
- Multiple URLs
- Forgiving URL syntax
- Human-readable status messages
- Basic configuration
- Automatic yt-dlp update checking after extraction failures

The underlying downloader remains yt-dlp.

This means that improvements and compatibility fixes in yt-dlp can be incorporated without having to reimplement YouTube extraction logic in this project.

---

# 📦 Files

The repository contains the following main files:

| File | Purpose |
|---|---|
| `installer.sh` | Installs and configures the required components |
| `yt` | Video-download wrapper |
| `ytmp3` | MP3-download wrapper |
| `yt-dlp-wrapper` | Shared wrapper containing the download, retry, transcript, configuration, and argument-handling logic |
| `uninstall.sh` | Removes the installed components and configuration |
| `README.md` | Documentation |

The installed files are normally placed in:

    ~/scripts/

---

# 🌍 Supported Platforms

## Linux

The project is primarily designed around a Unix-like command-line environment and works on common Linux distributions where Bash, curl, and the required dependencies are available.

## WSL

Windows users can run the project through WSL.

> 💡 **WSL:** Downloads are performed from the Linux environment, but Windows-mounted paths such as `/mnt/c/...` can be used normally.

## macOS

The wrappers work on macOS provided that Deno, FFmpeg, curl, and the yt-dlp binary are available.

Homebrew is a convenient way to install FFmpeg:

    brew install ffmpeg

## SteamOS

SteamOS is supported with special handling for FFmpeg installation because SteamOS uses a read-only system filesystem by default.

The rest of the setup can be used in the same general way as on other Linux systems.

---

# 🎓 Examples

## One video

    yt dQw4w9WgXcQ

## Several videos

    yt dQw4w9WgXcQ xYTeFnQ_lCU

## Several videos using semicolons

    yt 'dQw4w9WgXcQ;xYTeFnQ_lCU'

## Several videos using commas

    yt 'dQw4w9WgXcQ,xYTeFnQ_lCU'

## Full URLs

    yt \
      "https://youtu.be/dQw4w9WgXcQ" \
      "https://youtu.be/xYTeFnQ_lCU"

## Mixed input styles

    yt \
      dQw4w9WgXcQ \
      "youtu.be/xYTeFnQ_lCU" \
      "https://youtu.be/ANOTHER_ID"

## MP3

    ytmp3 dQw4w9WgXcQ

## MP3 batch

    ytmp3 dQw4w9WgXcQ xYTeFnQ_lCU

## Continue after errors

    yt --ignore-errors dQw4w9WgXcQ xYTeFnQ_lCU

## Configure

    yt --configure

## Show configuration

    yt --show-config

## Show help

    yt --help

---

# 📝 Notes

The wrapper deliberately accepts a broad range of convenient input forms.

For example, these all represent the same video:

    yt dQw4w9WgXcQ

    yt youtu.be/dQw4w9WgXcQ

    yt https://youtu.be/dQw4w9WgXcQ

The same applies when several inputs are provided:

    yt dQw4w9WgXcQ xYTeFnQ_lCU

    yt 'dQw4w9WgXcQ,xYTeFnQ_lCU'

    yt 'dQw4w9WgXcQ;xYTeFnQ_lCU'

This is intentional: the wrapper should make the common case easy rather than forcing the user to remember a particular URL representation.

Shell quoting is still necessary when an argument contains characters that have special meaning to the shell.

In particular, `;` is a shell command separator, so a semicolon-separated list must normally be quoted:

    yt 'dQw4w9WgXcQ;xYTeFnQ_lCU'

A space-separated list does not need quoting when using simple video IDs:

    yt dQw4w9WgXcQ xYTeFnQ_lCU

---

# 🤝 Contributing

Issues, suggestions, and improvements are welcome.

Before submitting a change, please make sure that:

- The wrapper remains valid Bash
- `bash -n` reports no syntax errors
- Existing command-line behavior is not unintentionally broken
- New functionality is documented in `README.md`
- Examples reflect the actual wrapper behavior
- Executable scripts remain executable
- Changes are kept reasonably small and focused

For wrapper changes, a useful minimum check is:

    bash -n yt
    bash -n ytmp3

Then test the relevant commands manually.

---

# 🐛 Reporting Issues

When reporting a problem, please include:

- Operating system
- Shell (`bash`, `zsh`, etc.)
- yt-dlp version
- Deno version
- FFmpeg version
- The exact command used
- Relevant error output

For example:

    yt-dlp --version
    deno --version
    ffmpeg -version

Please avoid posting authentication cookies, credentials, tokens, or other sensitive information.

---

# 📜 License

This project is licensed under the MIT License.

See [`LICENSE`](https://github.com/mmarkus13/yt-dlc/blob/main/LICENSE) for the complete license text.

yt-dlp is a separate project and is licensed under its own license.

FFmpeg is also a separate project and is distributed under its own licensing terms.

This repository does not claim ownership of yt-dlp, Deno, FFmpeg, YouTube, or any other third-party software or service referenced by this project.

---

# 🙏 Credits

This project is built on the excellent work of several open-source projects:

- [yt-dlp](https://github.com/yt-dlp/yt-dlp) — the core media downloader
- [Deno](https://deno.com/) — JavaScript/TypeScript runtime used by yt-dlp for JavaScript challenge solving
- [FFmpeg](https://ffmpeg.org/) — multimedia framework used for merging and media conversion

Thanks to all of the developers and contributors who maintain these projects.

---

# 🔗 Links

- [yt-dlc GitHub Repository](https://github.com/mmarkus13/yt-dlc)
- [yt-dlp](https://github.com/yt-dlp/yt-dlp)
- [Deno](https://deno.com/)
- [FFmpeg](https://ffmpeg.org/)

---

# ⭐ Support

If you find this project useful, consider giving the repository a star on GitHub.

If you encounter a problem, please open an issue with enough information to reproduce it, including:

- Your operating system
- Shell and version
- yt-dlp version
- Deno version
- FFmpeg version
- The command that was executed
- The relevant error output

Please do not include passwords, cookies, authentication tokens, or other sensitive information in issue reports.

---

# 📌 Important Notes

- The installer downloads the latest stable yt-dlp release during installation.
- If yt-dlp needs to be refreshed later, rerunning the installer updates the installed yt-dlp binary.
- Deno is the recommended JavaScript runtime for yt-dlp and must be version 2.3.0 or newer.
- FFmpeg is required for many video/audio processing operations, including merging separate video/audio streams and audio extraction.
- The official standalone yt-dlp binary does not require Python.
- The `yt`, `ytmp3`, and `yt-dlp-wrapper` scripts are maintained in this repository.
- The installer installs the yt-dlp executable and wrapper scripts into `~/scripts`.
- The wrappers first allow yt-dlp to use its normal/default YouTube client selection and retry with `player_client=web` when the normal extraction attempt fails.
- The wrappers accept multiple individual URLs as separate command-line arguments.
- URLs may also be supplied together in a single argument using commas or semicolons as separators.
- YouTube video IDs may be supplied directly without the `https://youtu.be/` prefix.
- Full YouTube URLs and `youtu.be/...` URLs are also accepted.
- Arguments beginning with `--` are interpreted as wrapper options; other arguments are treated as URL/video-ID input.
- `--ignore-errors` allows batch processing to continue after an individual download fails and reports failed URLs when the batch finishes.
- Transcript downloading is handled by the wrapper and does not cause an otherwise successful media download to fail when a transcript is unavailable.
- Output directories are stored in `~/.config/yt-dlc/config` and can be configured with `yt --configure`.
- Video downloads use `VIDEO_DIR`, while audio downloads use `MUSIC_DIR`.
- Avoid relying on permanently hard-coded YouTube client workarounds unless there is a current, reproducible reason to do so.
- Only download content you have the right to download and use.

---

# 🎬 Enjoy!

Keep it simple:

    yt dQw4w9WgXcQ

Multiple videos:

    yt dQw4w9WgXcQ xYTeFnQ_lCU

Or, when one of them might fail:

    yt --ignore-errors dQw4w9WgXcQ xYTeFnQ_lCU

For MP3:

    ytmp3 xYTeFnQ_lCU

Happy downloading! 🎵

