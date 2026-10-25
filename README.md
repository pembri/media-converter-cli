# Media Converter

**Media Converter by Rira Project** is an audio, video, and image converter for your terminal. Convert between common formats, with optional quality control, one file or many at once. Built for **Termux (Android)**.

## Features

- Convert **audio**: mp3, m4a, wav, opus, flac, aac, ogg, wma — with optional `--quality` (bitrate)
- Convert **video**: mp4, mkv, avi, mov, webm, flv, 3gp — with optional `--quality` (resolution)
- Convert **images**: jpg, jpeg, png, webp, bmp, gif, tiff — with optional `--quality` (high/medium/low)
- **Multi-file**: give several files and get them all converted in one run
- Every selection menu has a `0) Exit` option to cancel cleanly
- Progress bar for every conversion
- Built-in repair command (`--fix`) and one-command update (`--update`)
- Converted files are saved in separate Audio / Videos / Images folders, originals are never touched
- Colorized terminal UI that clears the screen before every run, so output never piles up
- Single-file installer and a clean uninstaller that never touches your converted files

## Requirements

- Termux (Android)
- Internet connection
- `git` (only to clone this repo): `pkg install git`

Everything else needed to run Media Converter is installed automatically by the installer.

## Installation

```bash
pkg install -y git && git clone https://github.com/pembri/media-converter-cli && cd media-converter-cli && chmod +x install.sh && ./install.sh
```

The installer will automatically:
1. Check that you are running Termux
2. Prepare the environment (a single progress bar, no clutter)
3. Check storage access (tap **Allow** when Android asks for permission)
4. Fetch and install the `media-converter` command so it can be run from anywhere

If you see `command not found` after installing, run `exec $SHELL` and try again.

## Usage

```bash
media-converter --audio "song.m4a" --convert mp3 --quality 320kbps
media-converter --videos "clip.avi" --convert mp4 --quality 1080p
media-converter --images "photo.png" --convert jpg --quality high
media-converter                       # interactive mode
media-converter --fix                 # refresh required components if conversions start failing
media-converter --update              # update to the latest version
media-converter --remove              # uninstall completely
```

`--quality` is always optional — if you leave it out, a sensible default is used.

Interactive mode looks like this:

```
 ###  ###  ####### ######  ########   ###
## #### ## ##      ##   ##    ##    ##   ##
##  ##  ## ####### ##   ##    ##    #######
##  ##  ## ##      ##   ##    ##    ##   ##
##  ##  ## ##      ##   ##    ##    ##   ##
##  ##  ## ####### ######  ######## ##   ##

  ####    ####   ###   ## ##    ## ####### ######  ######## ####### ######
###  ##  ##  ##  ####  ## ##    ## ##      ##   ##    ##    ##      ##   ##
##      ##    ## ##### ## ##    ## ####### ######     ##    ####### ######
##      ##    ## ## #####  ##  ##  ##      ## ##      ##    ##      ## ##
###  ##  ##  ##  ##  ####   ####   ##      ##  ##     ##    ##      ##  ##
  ####    ####   ##   ###    ##    ####### ##   ##    ##    ####### ##   ##

#################################################################\
##                       Media Converter                       ## |
##                Convert Audio, Video & Images                ## |
##                                                             ## |
##  Version   : v1.8                                           ## |
##  Developed : Rira Project                                   ## |
##  Github    : https://github.com/pembri/media-converter-cli  ## |
\################################################################ |
 \_________________________________________________________________/

Select Type
  1) Audio
  2) Videos
  3) Images
  0) Exit
```

Steps:
1. Choose **Audio**, **Videos** or **Images** (or `0` to exit)
2. Enter the file path (or several, separated by spaces)
3. Choose the target format (or `0` to exit)
4. Choose the quality, if the format offers one (or `0` to exit)
5. The converted files are saved to their matching folder

## Supported formats & quality

| Type | Formats | `--quality` options |
|---|---|---|
| Audio | mp3, m4a, aac, ogg, wma | 320/256/192/128/96 kbps (varies by format) |
| Audio | opus | 192/128/96/64 kbps |
| Audio | wav, flac | none (lossless) |
| Video | mp4, mkv, mov, webm | 1080p, 720p, 480p, 360p, 240p |
| Video | avi | 720p, 480p, 360p, 240p |
| Video | flv | 480p, 360p, 240p |
| Video | 3gp | 176x144, 352x288 (fixed sizes) |
| Image | jpg, jpeg, webp | high, medium, low |
| Image | png, bmp, gif, tiff | none (lossless/fixed) |

Run `media-converter --help` for the full list of options.

## Fixing conversion errors

```bash
media-converter --fix
```

This refreshes the components Media Converter depends on.

## Updating

```bash
media-converter --update
```

This pulls the latest version of this repo and reinstalls the `media-converter` command. Your converted files are never touched.

## Uninstalling

```bash
media-converter --remove
```

This removes the `media-converter` command and the installer's own files. Your converted files in `/sdcard/Download/media-converter` are always kept. You will be asked separately whether to also remove the components the installer added, if any.
