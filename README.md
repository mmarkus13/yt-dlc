# 🎵 YouTube Downloader CLI

A lightweight command-line YouTube downloader built around
[yt-dlp](https://github.com/yt-dlp/yt-dlp), Deno, and FFmpeg.

No GUI bloat, no complicated configuration — just a small Bash wrapper that
provides convenient defaults while still allowing long-form yt-dlp options to
be passed through when needed.

> Status: Tested in August 2026 with yt-dlp `2026.08.19` and Deno `2.9.5`.

---

# 🚀 Quick Install

The easiest way to install everything is:

```bash
mkdir -p ~/scripts && cd ~/scripts && \
curl -fsSL "https://raw.githubusercontent.com/mmarkus13/yt-dlc/main/installer.sh" \
  -o installer.sh && \
chmod +x installer.sh && \
./installer.sh
```

The installer:

- Creates `~/scripts`
- Creates `~/.local/bin`
- Adds both directories to the Bash `PATH`
- Installs Deno if it is not already installed
- Downloads the latest official standalone `yt-dlp` binary
- Installs `yt-dlp` to `~/.local/bin/yt-dlp`
- Checks for FFmpeg
- Offers to install FFmpeg if it is missing
- Installs `yt`, `ytmp3`, and `yt-dlp-wrapper` to `~/scripts`
- Makes the installed scripts executable

After installation, if the current shell does not yet see the new commands:

```bash
source ~/.bashrc
```

Then verify:

```bash
command -v yt
command -v ytmp3
command -v yt-dlp
```

The expected locations are similar to:

```text
/home/yourname/scripts/yt
/home/yourname/scripts/ytmp3
/home/yourname/.local/bin/yt-dlp
```

---

# ✨ Features

- Simple `yt VIDEO_ID` syntax
- Full YouTube URLs
- `youtu.be/...` URLs
- Multiple individual videos in one command
- Space-, comma-, and semicolon-separated inputs
- Automatic 2–5 second delay between separate batch inputs
- No automatic delay when downloading only one input
- Delay is applied only between inputs, never after the final input
- Best available video/audio by default
- MP4 output for video downloads when possible
- MP3 extraction through `ytmp3`
- Automatic retry after download failure
- Automatic yt-dlp update check after a failed download
- YouTube `web` client fallback after the normal retry fails
- Optional continuation after failures with `--ignore-errors`
- Transcript downloading
- Interactive configuration
- Long-form yt-dlp options can be passed through
- Explicit user yt-dlp options override compatible wrapper defaults
- Short yt-dlp options are intentionally rejected
- Wrapper-owned options are never passed to yt-dlp
- `--playlist-end`, `--playlist-items`, `--geo-bypass-country`,
  `--format`, `--output`, and many other long-form yt-dlp options are supported
- Designed for Linux, WSL, macOS, and SteamOS
- No system Python installation is required when using the standalone yt-dlp binary
- Wrapper diagnostics with `--diagnose`
- Wrapper self-update with `--update`
- One-step wrapper rollback with `--rollback`
- Per-command transcript overrides with `--transcript` and `--no-transcript`
- Configuration reset with `--reset-config`

---

# 📋 Prerequisites

The normal installation uses:

| Component | Purpose |
| --- | --- |
| Bash | Runs the wrapper scripts |
| curl | Downloads the installer and required components |
| yt-dlp | Performs the actual media extraction/download |
| Deno | JavaScript runtime used by yt-dlp for current YouTube extraction |
| FFmpeg | Merging, conversion, and MP3 extraction |

The installer handles yt-dlp and Deno automatically where necessary and can
offer to install FFmpeg.

## Python

Python is **not required** for the normal installation.

The project uses the official standalone yt-dlp executable, which does not
require a system Python installation.

If you intentionally choose to install yt-dlp through another method such as
PyPI, follow yt-dlp's own current installation requirements.

## Why Deno?

yt-dlp uses a JavaScript runtime for JavaScript challenge solving required by
current YouTube extraction.

Deno is the recommended runtime for this purpose.

The official standalone yt-dlp release already contains the required EJS
components, so this project does not separately install `yt-dlp-ejs`.

---

# 🔧 Installation

## Automatic installation

Use the Quick Install command shown above.

### The resulting layout is:

```text
~/scripts/
├── yt
├── ytmp3
└── yt-dlp-wrapper

~/.local/bin/
└── yt-dlp

~/.config/yt-dlc/
└── config

~/.cache/yt-dlc/
└── tmp
```

The distinction is intentional:

- `~/scripts/` contains commands/scripts that are directly used by the user
  or form part of the wrapper.
- `~/.local/bin/` contains the standalone `yt-dlp` executable.

`yt` and `ytmp3` are small launchers which invoke the shared
`yt-dlp-wrapper`.

## Manual installation

Create the directories:

```bash
mkdir -p "$HOME/scripts"
mkdir -p "$HOME/.local/bin"
```

Add them to your Bash `PATH`:

```bash
echo 'export PATH="$HOME/scripts:$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
source "$HOME/.bashrc"
```

Install Deno:

```bash
curl -fsSL https://deno.land/install.sh | sh
```

Then configure Deno for Bash:

```bash
echo 'export DENO_INSTALL="$HOME/.deno"' >> "$HOME/.bashrc"
echo 'export PATH="$DENO_INSTALL/bin:$PATH"' >> "$HOME/.bashrc"
source "$HOME/.bashrc"
```

Install yt-dlp:

```bash
curl -fsSL \
  "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp" \
  -o "$HOME/.local/bin/yt-dlp"

chmod +x "$HOME/.local/bin/yt-dlp"
```

Verify:

```bash
yt-dlp --version
deno --version
```

Then obtain the repository scripts:

```bash
git clone \
  "https://github.com/mmarkus13/yt-dlc.git" \
  "$HOME/yt-dlc"
```

Install them:

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

---
## Uninstalling

To remove yt-dlc, run:

```bash
./uninstall.sh
```

The uninstaller removes the files installed by the installer, including the `yt`, `ytmp3`, and `yt-dlp` commands and the `yt-dlp-wrapper` wrapper.

It does not remove the downloaded media files in your configured Video or Music directories.

---

# 🎬 Usage

## Download a video

The simplest form is a YouTube video ID:

```bash
yt dQw4w9WgXcQ
```

A shortened URL also works:

```bash
yt youtu.be/dQw4w9WgXcQ
```

A full URL works:

```bash
yt https://youtu.be/dQw4w9WgXcQ
```

Normal YouTube URLs are also passed through:

```bash
yt "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
```

---

# 🎵 Download audio as MP3

Use `ytmp3`:

```bash
ytmp3 xYTeFnQ_lCU
```

The wrapper extracts the best available audio and converts it to MP3 using
FFmpeg.

---

# 📚 Multiple Downloads

Multiple individual videos can be supplied directly:

```bash
yt dQw4w9WgXcQ xYTeFnQ_lCU
```

You can mix IDs and URLs:

```bash
yt \
  dQw4w9WgXcQ \
  youtu.be/xYTeFnQ_lCU \
  "https://youtu.be/ANOTHER_ID"
```

The same works with `ytmp3`:

```bash
ytmp3 dQw4w9WgXcQ xYTeFnQ_lCU
```

Each input is processed independently.

---

# 🔀 Input Separators

Inputs may be separated by spaces, commas, or semicolons.

## Spaces

```bash
yt dQw4w9WgXcQ xYTeFnQ_lCU
```

## Commas

```bash
yt 'dQw4w9WgXcQ,xYTeFnQ_lCU'
```

## Semicolons

```bash
yt 'dQw4w9WgXcQ;xYTeFnQ_lCU'
```

They can also be mixed:

```bash
yt 'dQw4w9WgXcQ, xYTeFnQ_lCU; ANOTHER_ID'
```

### Shell quoting

Semicolons have a special meaning to most shells.

Therefore, a semicolon-separated list should normally be quoted:

```bash
yt 'dQw4w9WgXcQ;xYTeFnQ_lCU'
```

A simple space-separated list does not need quoting:

```bash
yt dQw4w9WgXcQ xYTeFnQ_lCU
```

---

# ⏳ Automatic Batch Delay

When multiple individual inputs are supplied, the wrapper automatically waits
a randomized **2–5 seconds between downloads**.

For example:

```bash
yt VIDEO_ID_1 VIDEO_ID_2 VIDEO_ID_3
```

behaves conceptually like:

```text
download VIDEO_ID_1
wait 2–5 seconds
download VIDEO_ID_2
wait 2–5 seconds
download VIDEO_ID_3
```

There is **no automatic delay when there is only one input**.

The delay is also applied only between inputs. The wrapper does not wait after
the final download.

The delay is intentionally not exposed as a wrapper configuration setting.
The purpose is to avoid unnecessarily aggressive request patterns during
ordinary batch downloads without making normal single-video usage slower.

If you explicitly provide a yt-dlp timing option such as:

```bash
yt --sleep-interval 5 VIDEO_ID
```

that option is passed through to yt-dlp.

---

# ⚙️ yt-dlp Options

The wrapper is not intended to duplicate the entire yt-dlp command-line
interface.

Instead, it provides its own small interface while allowing **long-form
yt-dlp options** to be passed through.

This means useful yt-dlp functionality does not have to be reimplemented by
the wrapper.

## Examples

Format selection:

```bash
yt --format best VIDEO_ID
```

Custom format:

```bash
yt --format 'bestvideo[height<=1080]+bestaudio/best' VIDEO_ID
```

Output template:

```bash
yt --output '/tmp/%(title)s.%(ext)s' VIDEO_ID
```

Playlist limit:

```bash
yt --playlist-end 20 PLAYLIST_URL
```

Specific playlist items:

```bash
yt --playlist-items 1,3,5 PLAYLIST_URL
```

Geo-bypass country:

```bash
yt --geo-bypass-country US VIDEO_ID
```

Custom sleep interval:

```bash
yt --sleep-interval 5 VIDEO_ID
```

Multiple options can be combined:

```bash
yt \
  --playlist-end 20 \
  --format 'bestvideo[height<=1080]+bestaudio/best' \
  PLAYLIST_URL
```

## User options override wrapper defaults

The wrapper establishes defaults such as:

```text
video format
output path
output filename
overwrite behavior
```

User-supplied long-form yt-dlp options are placed after those defaults.

Therefore, when a supplied option conflicts with a compatible wrapper default,
the explicit user option wins.

For example:

```bash
yt --format best VIDEO_ID
```

causes the user's `--format best` selection to take precedence over the
wrapper's normal video format selection.

This is intentional: a user explicitly specifying a yt-dlp option is assumed
to know why they are specifying it.

---

# 🚫 Short yt-dlp Options

Short-form yt-dlp options are intentionally **not accepted** by the wrapper.

For example:

```bash
yt -f best VIDEO_ID
```

is rejected.

Use:

```bash
yt --format best VIDEO_ID
```

instead.

Similarly:

```text
-f  → --format
-o  → --output
-I  → --playlist-items
```

## Why are short options rejected?

YouTube video IDs are exactly 11 characters long and may contain:

```text
A-Z
a-z
0-9
-
_
```

That means a valid video ID can itself begin with `-`.

For example:

```text
-aBcDeFgHiJ
```

If arbitrary short options were accepted, an accidental space or malformed
command could cause a valid YouTube ID to be interpreted as an option.

The wrapper therefore deliberately keeps the distinction unambiguous:

- Valid 11-character YouTube IDs are accepted, including IDs beginning with `-`.
- Long-form arguments beginning with `--` are treated as options.
- Short-form arguments beginning with `-` are rejected.

---

# 🧩 Wrapper-Owned Options

The wrapper provides a small number of its own options.

## `--ignore-errors`

Continue processing remaining inputs after an individual failure:

```bash
yt --ignore-errors VIDEO_ID_1 VIDEO_ID_2 VIDEO_ID_3
```

Without this option, the batch stops when a download fails.

With it, failed inputs are recorded and the remaining inputs continue.

At the end, the wrapper reports the successful and failed downloads.

## `--show-config`

Show the current wrapper configuration:

```bash
yt --show-config
```

## `--configure`

Configure wrapper-specific settings:

```bash
yt --configure
```

## `--help`

Show the wrapper help:

```bash
yt --help
```

---

# 🚫 Options Controlled by the Wrapper

Some options are deliberately owned by the wrapper and are not passed through
to yt-dlp.

In particular:

```text
--ignore-errors
--show-config
--configure
--reset-config
--diagnose
--help
--batch-file
--update
--rollback
```

The wrapper needs to control these behaviors itself.

This prevents a yt-dlp option from accidentally bypassing functionality that
belongs to the wrapper.

---

# 📋 Configuration

Run:

```bash
yt --configure
```

The configuration interface currently manages:

- Video download directory
- Music download directory
- Transcript downloading
- Transcript language
- Whether existing files should be overwritten

The configuration is stored in:

```text
~/.config/yt-dlc/config
```

Temporary yt-dlp files are stored under:

```text
~/.cache/yt-dlc/tmp
```

## View the current configuration

```bash
yt --show-config
```

Example:

```text
Current download preferences
-----------------------------
  Video directory:        /home/user/Videos
  Music directory:        /home/user/Music
  Transcripts:             Yes (en)
  Overwrite files:         No
  Temporary files:         /home/user/.cache/yt-dlc/tmp
```

The configuration prompts support normal Bash line editing, including arrow
keys, when the wrapper is run interactively.

## Reset configuration
    yt --reset-config
---

# 📁 Download Locations

Video downloads use the configured `VIDEO_DIR`.

MP3 downloads use the configured `MUSIC_DIR`.

If no directory is configured, the current working directory is used.

The output filename is based on:

```text
%(title)s [%(id)s].%(ext)s
```

For example:

```text
Rick Astley - Never Gonna Give You Up [dQw4w9WgXcQ].mp4
```

The wrapper normally avoids overwriting an existing file.

This can be changed through the configuration interface.

---

# 📝 Transcripts

When transcript downloading is enabled, the wrapper attempts to download
subtitles after a successful media download.

The configured language is tried first.

If that language is unavailable, the wrapper attempts to find another uploaded
subtitle and then an automatically generated subtitle.

Downloaded VTT subtitles are converted into plain text files.

Transcript failure does **not** turn an otherwise successful media download
into a failed download.

### Per-command transcript overrides

You can override the configured transcript setting for a single command without changing the persistent configuration:

```bash
# Enable transcripts for this command only
./yt-dlp-wrapper --transcript VIDEO_ID

# Disable transcripts for this command only
./yt-dlp-wrapper --no-transcript VIDEO_ID
```

---

# 🔄 Automatic Retry and Fallback

When a normal download fails, the wrapper performs additional recovery steps.

The general sequence is:

```text
normal yt-dlp attempt
        ↓
yt-dlp update check
        ↓
normal retry
        ↓
YouTube web-client fallback
```

The web-client fallback uses:

```text
--extractor-args "youtube:player_client=web"
```

The wrapper does **not** force the web client for every download.

This is intentional.

yt-dlp's normal client selection should be allowed to work first, while the
web client provides an additional recovery path when normal extraction fails.

The fallback cannot solve every failure.

For example, it cannot automatically make a:

- deleted video
- private video
- unavailable video
- authentication-protected video
- genuinely region-restricted video

available.

---

# 🌍 Geo Options

Long-form geo-related yt-dlp options can be supplied directly.

For example:

```bash
yt --geo-bypass-country US VIDEO_ID
```

The wrapper does not automatically change the user's requested country.

If the user explicitly supplies a geo option, it is passed through to yt-dlp.

Automatic geo-routing is not currently performed by the wrapper.

---

# 🎬 Playlists

Playlist URLs can be passed directly to yt-dlp:

```bash
yt "https://www.youtube.com/playlist?list=PLAYLIST_ID"
```

Playlist-specific yt-dlp options can also be supplied:

```bash
yt --playlist-end 20 \
   "https://www.youtube.com/playlist?list=PLAYLIST_ID"
```

Or:

```bash
yt --playlist-items 1,3,5 \
   "https://www.youtube.com/playlist?list=PLAYLIST_ID"
```

For playlist URLs, use the complete URL so that query parameters remain intact.

The wrapper's convenient ID/URL normalization is primarily intended for
individual video inputs.

---

# ❌ Error Handling

A failed download normally stops the batch:

```bash
yt VIDEO_ID_1 VIDEO_ID_2 VIDEO_ID_3
```

If `VIDEO_ID_1` fails, the wrapper reports the failure and stops.

Use:

```bash
yt --ignore-errors VIDEO_ID_1 VIDEO_ID_2 VIDEO_ID_3
```

to continue after failures.

At the end of an ignored-error batch, the wrapper reports:

```text
Successful: X
Failed:     Y
```

and lists the failed URLs.

The command still exits with a failure status if one or more downloads failed.

---

# 🧪 Testing

After installation, verify the individual components.

## Check the commands

```bash
command -v yt
command -v ytmp3
command -v yt-dlp
```

Expected locations:

```text
/home/yourname/scripts/yt
/home/yourname/scripts/ytmp3
/home/yourname/.local/bin/yt-dlp
```

## Check Bash syntax

```bash
bash -n ~/scripts/yt
bash -n ~/scripts/ytmp3
bash -n ~/scripts/yt-dlp-wrapper
bash -n ~/scripts/installer.sh
```

## Test Deno

```bash
deno --version
```

## Test FFmpeg

```bash
ffmpeg -version
```

## Test yt-dlp

```bash
yt-dlp --version
```

## Test video download

```bash
yt dQw4w9WgXcQ
```

## Test MP3 extraction

```bash
ytmp3 xYTeFnQ_lCU
```

## Test multiple inputs

```bash
yt dQw4w9WgXcQ xYTeFnQ_lCU
```

This should trigger the automatic delay between the two inputs.

## Test long-form yt-dlp options

```bash
yt --format best dQw4w9WgXcQ
```

```bash
yt --playlist-end 20 dQw4w9WgXcQ
```

```bash
yt --geo-bypass-country US dQw4w9WgXcQ
```

```bash
yt --sleep-interval 5 dQw4w9WgXcQ
```

## Test short-option rejection

```bash
yt -f best dQw4w9WgXcQ
```

This should be rejected by the wrapper.

## Test a leading-hyphen video ID

```bash
yt -aBcDeFgHiJ
```

The wrapper should recognize this as an 11-character YouTube ID rather than
as a short option.

The resulting download may naturally fail if that particular ID does not
exist; the important part of this test is that it is interpreted as a video
ID.

---

# 🛠️ Troubleshooting

## `yt: command not found`

Check:

```bash
echo "$PATH"
```

Make sure `~/scripts` is present.

For Bash:

```bash
echo 'export PATH="$HOME/scripts:$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
source "$HOME/.bashrc"
```

Then:

```bash
command -v yt
```

## `yt-dlp: command not found`

Check:

```bash
ls -l "$HOME/.local/bin/yt-dlp"
```

If necessary, reinstall the standalone binary:

```bash
curl -fsSL \
  "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp" \
  -o "$HOME/.local/bin/yt-dlp"

chmod +x "$HOME/.local/bin/yt-dlp"
```

Then:

```bash
yt-dlp --version
```

## Deno is not found

Check:

```bash
deno --version
```

If unavailable:

```bash
export DENO_INSTALL="$HOME/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"
```

For a permanent Bash configuration:

```bash
echo 'export DENO_INSTALL="$HOME/.deno"' >> "$HOME/.bashrc"
echo 'export PATH="$DENO_INSTALL/bin:$PATH"' >> "$HOME/.bashrc"
source "$HOME/.bashrc"
```

## FFmpeg is not found

Check:

```bash
ffmpeg -version
```

On Debian/Ubuntu/WSL:

```bash
sudo apt update
sudo apt install -y ffmpeg
```

On macOS with Homebrew:

```bash
brew install ffmpeg
```

On systems using pacman:

```bash
sudo pacman -S --needed ffmpeg
```

SteamOS may require additional consideration because of its read-only system
filesystem. The installer can attempt installation using the available
package manager.

## A video says "unavailable"

First verify that the video is actually available in a normal browser.

Possible reasons include:

- Deleted video
- Private video
- Region restriction
- Age restriction
- Members-only content
- Authentication requirements
- Temporary YouTube/client issues
- Incorrect video ID

The wrapper automatically retries using the YouTube web client, but this is a
fallback mechanism, not a guarantee that an unavailable video can be accessed.

## JavaScript challenge errors

Check:

```bash
deno --version
yt-dlp --version
```

Make sure Deno is available in the current shell.

The project uses the official standalone yt-dlp release together with Deno.

If yt-dlp is outdated, rerun the installer or update the installed binary.

## Short options are rejected

This is intentional.

Instead of:

```bash
yt -f best VIDEO_ID
```

use:

```bash
yt --format best VIDEO_ID
```

This avoids ambiguity with valid YouTube IDs that can begin with `-`.

## Configuration arrows do not work

The configuration interface uses Bash's readline support for free-form text
fields.

If arrow keys appear literally as escape sequences such as:

```text
^[[D
```

make sure the installed `yt-dlp-wrapper` is the current version and that it is
being executed by Bash.

Check:

```bash
head -n1 ~/scripts/yt-dlp-wrapper
```

It should show:

```text
#!/usr/bin/env bash
```

Then verify the script:

```bash
bash -n ~/scripts/yt-dlp-wrapper
```

---

# 🔄 Updating / Reinstalling

The installer can be run again to refresh the installation:

```bash
cd ~/scripts
./installer.sh
```

Or download the current installer again:

```bash
curl -fsSL \
  "https://raw.githubusercontent.com/mmarkus13/yt-dlc/main/installer.sh" \
  -o ~/scripts/installer.sh

chmod +x ~/scripts/installer.sh
~/scripts/installer.sh
```

The installer downloads:

```text
yt
ytmp3
yt-dlp-wrapper
```

to:

```text
~/scripts/
```

and installs/updates:

```text
yt-dlp
```

at:

```text
~/.local/bin/yt-dlp
```

If the repository has been cloned:

```bash
cd ~/yt-dlc
git pull
```

Then the scripts can be copied manually:

```bash
cp yt ytmp3 yt-dlp-wrapper ~/scripts/
chmod +x ~/scripts/yt ~/scripts/ytmp3 ~/scripts/yt-dlp-wrapper
```

Verify:

```bash
yt-dlp --version
deno --version
ffmpeg -version
```

---

# 📦 Repository Files

The main repository files are:

| File | Purpose |
| --- | --- |
| `installer.sh` | Automated installer |
| `yt` | Video-mode launcher |
| `ytmp3` | MP3-mode launcher |
| `yt-dlp-wrapper` | Shared implementation |
| `README.md` | Documentation |
| `uninstall.sh` | Uninstaller, if present in the repository |

The two public commands are:

```text
yt
ytmp3
```

Both invoke the shared:

```text
~/scripts/yt-dlp-wrapper
```

The actual yt-dlp executable is kept separately in:

```text
~/.local/bin/yt-dlp
```

This separation is intentional.

---

# 🗂️ Directory Structure

After installation, the relevant files look like:

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
└── .cache/
    └── yt-dlc/
        └── tmp/
```

User-configured downloads may be located elsewhere, for example:

```text
~/Videos/
~/Music/
```

or any directories selected through:

```bash
yt --configure
```

---

# 🌍 Supported Platforms

## Linux

The project is designed primarily for Unix-like command-line environments and
works on Linux systems where Bash, curl, Deno, FFmpeg, and the required
permissions are available.

## WSL

The project works under Windows Subsystem for Linux.

Windows-mounted directories such as:

```text
/mnt/c/Users/username/Videos
```

can be used as download directories.

## macOS

The wrapper can be used on macOS provided that Bash, curl, Deno, FFmpeg, and
the yt-dlp binary are available.

Homebrew is a convenient way to install FFmpeg:

```bash
brew install ffmpeg
```

## SteamOS

SteamOS is supported.

The wrapper itself operates as a normal Bash application in the user's home
directory.

FFmpeg installation may require special consideration because SteamOS uses a
read-only system filesystem by default.

The installer can attempt to install FFmpeg using `pacman` when available.

---

# 🔐 Security and Argument Handling

The wrapper intentionally avoids treating arbitrary positional arguments as
shell commands.

Arguments are classified explicitly.

## YouTube IDs

An 11-character value matching:

```text
[A-Za-z0-9_-]{11}
```

is treated as a YouTube video ID.

This includes IDs beginning with `-`.

## Long-form options

Arguments beginning with:

```text
--
```

are interpreted as options.

Supported yt-dlp long-form options are passed through to yt-dlp.

## Short options

Arguments beginning with a single `-` that are not valid YouTube IDs are
rejected.

This is deliberate to prevent ambiguity between short yt-dlp options and valid
YouTube IDs.

## Wrapper-owned options

Wrapper-specific options are consumed by the wrapper and are **never passed to
yt-dlp**.

This includes:

```text
--ignore-errors
--show-config
--configure
--reset-config
--diagnose
--update
--rollback
--transcript / --no-transcript
--help
```

and wrapper-controlled functionality such as its batch handling.

# 🔄 Wrapper Maintenance

## Check wrapper health

    yt --diagnose

## Update the wrapper

    yt --update

## Roll back the wrapper

    yt --rollback

---

# 🧠 Design Philosophy

The project is intentionally a wrapper rather than a replacement for yt-dlp.

The underlying downloader remains yt-dlp.

The wrapper exists to provide a small number of conveniences:

- Sensible video defaults
- MP3 extraction through `ytmp3`
- Simple YouTube ID handling
- Convenient URL handling
- Multiple-input support
- Automatic batch pacing
- Automatic retry
- yt-dlp update checking after failures
- YouTube web-client fallback
- Transcript handling
- Simple configuration
- Human-readable status messages

The goal is to avoid reimplementing yt-dlp functionality unnecessarily.

When yt-dlp already provides a useful feature, the wrapper can expose it by
allowing its long-form command-line option to pass through.

---

# 🎓 Examples

## One video

```bash
yt dQw4w9WgXcQ
```

## Several videos

```bash
yt dQw4w9WgXcQ xYTeFnQ_lCU
```

## Comma-separated

```bash
yt 'dQw4w9WgXcQ,xYTeFnQ_lCU'
```

## Semicolon-separated

```bash
yt 'dQw4w9WgXcQ;xYTeFnQ_lCU'
```

## Full URLs

```bash
yt \
  "https://youtu.be/dQw4w9WgXcQ" \
  "https://youtu.be/xYTeFnQ_lCU"
```

## MP3

```bash
ytmp3 dQw4w9WgXcQ
```

## Continue after errors

```bash
yt --ignore-errors \
  dQw4w9WgXcQ \
  xYTeFnQ_lCU
```

## Limit a playlist

```bash
yt \
  --playlist-end 20 \
  "https://www.youtube.com/playlist?list=PLAYLIST_ID"
```

## Select a format

```bash
yt \
  --format 'bestvideo[height<=1080]+bestaudio/best' \
  dQw4w9WgXcQ
```

## Use a geo-bypass country

```bash
yt --geo-bypass-country US dQw4w9WgXcQ
```

## Set a yt-dlp sleep interval

```bash
yt --sleep-interval 5 dQw4w9WgXcQ
```

## Configure

```bash
yt --configure
```

## Show configuration

```bash
yt --show-config
```

## Show help

```bash
yt --help
```

---

# 📝 Important Notes

- `yt` and `ytmp3` are the user-facing commands.
- `yt-dlp-wrapper` contains the shared implementation and is not intended to
  be called directly during normal use.
- `yt-dlp` is installed in `~/.local/bin/yt-dlp`.
- User-facing wrapper scripts remain in `~/scripts`.
- The wrapper accepts YouTube video IDs, shortened URLs, and full URLs.
- YouTube IDs are exactly 11 characters and may contain `-` and `_`.
- Short yt-dlp options are intentionally rejected.
- Long-form yt-dlp options are passed through.
- Explicit user yt-dlp options override compatible wrapper defaults.
- Wrapper-owned options are not passed to yt-dlp.
- Multiple individual inputs automatically receive a randomized 2–5 second
  delay between downloads.
- A single input does not receive the automatic batch delay.
- The automatic delay occurs only between inputs, never after the last input.
- `--ignore-errors` controls whether a failed input stops the batch.
- Playlist URLs should normally be supplied as complete URLs.
- The wrapper retries failed downloads and can fall back to the YouTube web
  client.
- The fallback does not guarantee that an unavailable or restricted video can
  be downloaded.
- Transcript failure does not cause an otherwise successful media download to
  fail.
- Output directories are stored in `~/.config/yt-dlc/config`.
- Temporary files are stored under `~/.cache/yt-dlc/tmp`.
- FFmpeg is required for MP3 extraction and is often required for merging
  separate video and audio streams.
- The standalone yt-dlp binary does not require Python.
- Only download content you have the right to download and use.

---

# 🤝 Contributing

Issues, suggestions, and improvements are welcome.

Before submitting a change, please verify that:

- The wrapper remains valid Bash.
- `bash -n` reports no syntax errors.
- Existing command-line behavior is not unintentionally broken.
- New functionality is documented in `README.md`.
- Examples reflect the actual wrapper behavior.
- Executable scripts remain executable.
- Changes remain reasonably small and focused.

For wrapper changes, at minimum:

```bash
bash -n yt
bash -n ytmp3
bash -n yt-dlp-wrapper
```

For installer changes:

```bash
bash -n installer.sh
```

Relevant commands should then be tested manually on the target platform.

---

# 🐛 Reporting Issues

When reporting a problem, include:

- Operating system
- Shell and version
- yt-dlp version
- Deno version
- FFmpeg version
- Exact command used
- Relevant error output

Useful diagnostic commands are:

```bash
command -v yt
command -v ytmp3
command -v yt-dlp

yt-dlp --version
deno --version
ffmpeg -version
```

Please do not post:

- Passwords
- Authentication cookies
- Access tokens
- API credentials
- Other sensitive information

---

# 🔗 Links

Repository:

```text
https://github.com/mmarkus13/yt-dlc
```

yt-dlp:

```text
https://github.com/yt-dlp/yt-dlp
```

Deno:

```text
https://deno.com/
```

FFmpeg:

```text
https://ffmpeg.org/
```

---

# 📜 License

This project is licensed under the MIT License.

See:

```text
https://github.com/mmarkus13/yt-dlc/blob/main/LICENSE
```

yt-dlp is a separate project and is licensed under its own license.

FFmpeg is also a separate project and is distributed under its own licensing
terms.

This repository does not claim ownership of yt-dlp, Deno, FFmpeg, YouTube, or
any other third-party software or service referenced by this project.

---

# 🙏 Credits

This project is built on the work of several open-source projects:

- [yt-dlp](https://github.com/yt-dlp/yt-dlp) — core media downloader
- [Deno](https://deno.com/) — JavaScript/TypeScript runtime used by yt-dlp
- [FFmpeg](https://ffmpeg.org/) — multimedia framework for merging and
  conversion

Thanks to the developers and contributors who maintain these projects.

---

# ⭐ Support

If you find the project useful, consider giving the repository a star on
GitHub.

If you encounter a problem, please open an issue with enough information to
reproduce it.

Happy downloading! 🎵
