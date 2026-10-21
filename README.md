# Media Converter

**Media Converter by Rira Project** is an audio, video, and image converter for your terminal. Convert between common formats, one file or many at once. Built for **Termux (Android)**.

## Features

- Convert **audio**: mp3, m4a, wav, opus, flac, aac, ogg, wma
- Convert **video**: mp4, mkv, avi, mov, webm, flv, 3gp
- Convert **images**: jpg, jpeg, png, webp, bmp, gif, tiff
- **Multi-file**: give several files and get them all converted in one run
- Progress bar for every conversion
- Built-in repair command (`--fix`) and one-command update (`--update`)
- Converted files are saved in separate Audio / Videos / Images folders, originals are never touched
- Colorized, easy-to-read terminal UI
- Single-file installer and a clean uninstaller that never touches your converted files

## Requirements

- Termux (Android)
- Internet connection
- `git` (only to clone this repo): `pkg install git`

Everything else (Python and FFmpeg) is installed by the installer.

## Installation

```bash
pkg install -y git && git clone https://github.com/pembri/media-converter-cli && cd media-converter-cli && chmod +x install.sh && ./install.sh
```

The installer will automatically:
1. Check that you are running Termux
2. Install `python` and `ffmpeg`
3. Check storage access
4. Fetch the `media-converter` command

## Usage

```bash
media-converter --audio "song.m4a" --convert mp3
media-converter --videos "clip.avi" --convert mp4
media-converter --images "photo.png" --convert jpg
media-converter                       # interactive mode
media-converter --fix                 # reinstall ffmpeg if conversions start failing
media-converter --update              # update to the latest version
media-converter --remove              # uninstall completely
```

Converted files are saved to `/sdcard/Download/media-converter/Audio`, `/Videos`, or `/Images`, keeping the original file name with the new extension.

Run `media-converter --help` for the full list of options and supported formats.
