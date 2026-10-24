#!/data/data/com.termux/files/usr/bin/bash
# Media Converter installer for Termux (single file)
# Usage: ./install.sh

APP="media-converter"
PREFIX="${PREFIX:-/data/data/com.termux/files/usr}"
BIN="$PREFIX/bin/$APP"
OUT_DIR="/sdcard/Download/media-converter"
RECORD="$HOME/.media-converter"
SRC_DIR="$(cd "$(dirname "$0")" && pwd)"

API_BASE="https://riracloud.my.id/api/media-converter-cli"
API_KEY="950d1628d56fbc1b7ffc0c64ed4032d9c4a72563441e3c41fd8d949a9395ee5a"
REPO_URL="https://github.com/pembri/media-converter-cli"

if [ -t 1 ]; then
  C_B=$'\033[1;36m'; C_W=$'\033[1;37m'; C_D=$'\033[2m'
  C_G=$'\033[32m'; C_R=$'\033[31m'; C_0=$'\033[0m'
else
  C_B=""; C_W=""; C_D=""; C_G=""; C_R=""; C_0=""
fi

clear_screen() { [ -t 1 ] && printf '\033[2J\033[3J\033[H'; }

print_header() {
  local title="Media Converter"
  local subtitle="Convert Audio, Video & Images"
  local dev_label="Developed" dev_value="Rira Project"
  local gh_label="Github" gh_value="${REPO_URL#*github.com/}"
  local w=0 l
  for l in "$title" "$subtitle" "${dev_label} : ${dev_value}" "${gh_label} : ${gh_value}"; do
    [ ${#l} -gt "$w" ] && w=${#l}
  done
  w=$(( w + 4 ))

  local line; line=$(printf '═%.0s' $(seq 1 "$w"))
  printf '%s╔%s╗%s\n' "$C_B" "$line" "$C_0"

  local pad left right
  pad=$(( w - ${#title} )); left=$(( pad / 2 )); right=$(( pad - left ))
  printf '%s║%s%*s%s%s%s%*s%s║%s\n' "$C_B" "$C_0" "$left" '' "$C_W" "$title" "$C_0" "$right" '' "$C_B" "$C_0"

  pad=$(( w - ${#subtitle} )); left=$(( pad / 2 )); right=$(( pad - left ))
  printf '%s║%s%*s%s%s%s%*s%s║%s\n' "$C_B" "$C_0" "$left" '' "$C_D" "$subtitle" "$C_0" "$right" '' "$C_B" "$C_0"

  local text pad2
  text="${dev_label} : ${dev_value}"
  pad2=$(( w - ${#text} - 1 ))
  printf '%s║%s%*s%s%s%s : %s%s%s %s║%s\n' "$C_B" "$C_0" "$pad2" '' "$C_D" "$dev_label" "$C_0" "$C_W" "$dev_value" "$C_0" "$C_B" "$C_0"

  text="${gh_label} : ${gh_value}"
  pad2=$(( w - ${#text} - 1 ))
  printf '%s║%s%*s%s%s%s : %s%s%s %s║%s\n' "$C_B" "$C_0" "$pad2" '' "$C_D" "$gh_label" "$C_0" "$C_W" "$gh_value" "$C_0" "$C_B" "$C_0"

  printf '%s╚%s╝%s\n' "$C_B" "$line" "$C_0"
}

WIDTH=30
STATE_DIR="$(mktemp -d)"
cleanup() { rm -rf "$STATE_DIR"; }
trap cleanup EXIT

DONE_STEPS=()
LAST_LINES=0

draw_bar() {
  local pct=$1 label=$2
  local filled=$(( pct * WIDTH / 100 ))
  local empty=$(( WIDTH - filled ))
  local bar="" i
  for ((i = 0; i < filled; i++)); do bar+="#"; done
  for ((i = 0; i < empty; i++)); do bar+="-"; done
  printf '%s[%s]%s %3d%%  %s' "$C_B" "$bar" "$C_0" "$pct" "$label"
}

render() {
  local pct="$1" label="$2"
  if [ "$LAST_LINES" -gt 0 ]; then
    printf '\033[%dA\033[J' "$LAST_LINES"
  fi
  local item
  for item in "${DONE_STEPS[@]}"; do
    printf '%s✔%s %s\n' "$C_G" "$C_0" "$item"
  done
  draw_bar "$pct" "$label"
  echo
  LAST_LINES=$(( ${#DONE_STEPS[@]} + 1 ))
}

finish_render() {
  if [ "$LAST_LINES" -gt 0 ]; then
    printf '\033[%dA\033[J' "$LAST_LINES"
  fi
  local item
  for item in "${DONE_STEPS[@]}"; do
    printf '%s✔%s %s\n' "$C_G" "$C_0" "$item"
  done
  LAST_LINES=0
}

die() {
  finish_render
  printf '\n%s✖ %s%s\n' "$C_R" "$1" "$C_0"
  exit 1
}

run_step() {
  local label="$1" start="$2" end="$3"; shift 3
  render "$start" "$label"
  ( "$@" ) >"$STATE_DIR/log" 2>&1 &
  local pid=$!
  local pct=$start
  while kill -0 "$pid" 2>/dev/null; do
    sleep 0.2
    if [ "$pct" -lt $(( end - 1 )) ]; then pct=$(( pct + 1 )); fi
    render "$pct" "$label"
  done
  wait "$pid"
  local rc=$?
  render "$end" "$label"
  if [ "$rc" -eq 0 ]; then
    DONE_STEPS+=("$label")
  fi
  return $rc
}

clear_screen
print_header
echo

render 0 "Checking environment"
if ! { [ -d "$PREFIX/bin" ] && command -v pkg >/dev/null 2>&1; }; then
  die "This installer is for Termux only."
fi
render 5 "Checking environment"
DONE_STEPS+=("Checking environment")

HAD_PYTHON=0; command -v python3 >/dev/null 2>&1 && HAD_PYTHON=1
HAD_FFMPEG=0; command -v ffmpeg >/dev/null 2>&1 && HAD_FFMPEG=1

prepare_env() {
  apt-get update >/dev/null 2>&1
  pkg install -y python ffmpeg >/dev/null 2>&1 || return 1
  command -v python3 >/dev/null 2>&1 || return 1
  command -v ffmpeg >/dev/null 2>&1 || return 1
  return 0
}
export -f prepare_env

run_step "Preparing environment" 5 65 bash -c prepare_env \
  || die "Could not prepare the environment. Check your internet connection and try again."

NEW_PKGS=""
[ "$HAD_PYTHON" = 0 ] && command -v python3 >/dev/null 2>&1 && NEW_PKGS="$NEW_PKGS python"
[ "$HAD_FFMPEG" = 0 ] && command -v ffmpeg >/dev/null 2>&1 && NEW_PKGS="$NEW_PKGS ffmpeg"

storage_wait() {
  mkdir -p "$OUT_DIR" 2>/dev/null
  [ -w "$OUT_DIR" ] && return 0
  termux-setup-storage >/dev/null 2>&1
  local i
  for i in $(seq 1 45); do
    sleep 2
    mkdir -p "$OUT_DIR" 2>/dev/null
    [ -w "$OUT_DIR" ] && return 0
  done
  return 1
}
export -f storage_wait
export OUT_DIR

run_step "Checking storage access" 65 85 bash -c storage_wait \
  || die "No access to /sdcard. Run 'termux-setup-storage', tap Allow, then run ./install.sh again."

fetch_cmd() {
  command -v curl >/dev/null 2>&1 || pkg install -y curl >/dev/null 2>&1
  command -v curl >/dev/null 2>&1 || return 1
  local code
  code="$(curl -sS -o "$BIN.new" -w '%{http_code}' -H "X-MEDIACONV-KEY: $API_KEY" "$API_BASE/download")"
  echo "$code" > "$STATE_DIR/http_code"
  [ "$code" = "200" ] && [ -s "$BIN.new" ]
}
export -f fetch_cmd
export BIN API_KEY API_BASE STATE_DIR

if ! run_step "Fetching the media-converter command" 85 100 bash -c fetch_cmd; then
  CODE="$(cat "$STATE_DIR/http_code" 2>/dev/null || echo '000')"
  rm -f "$BIN.new"
  die "Could not fetch media-converter (HTTP $CODE). Check your internet connection and try again."
fi

finish_render
echo

chmod 755 "$BIN.new"
mv -f "$BIN.new" "$BIN" || die "Could not install $BIN"

REMOTE_VERSION="$(curl -sS -H "X-MEDIACONV-KEY: $API_KEY" "$API_BASE/version" 2>/dev/null)"
PREV=""
[ -f "$RECORD" ] && PREV="$(grep -E '^(pkg|pip):' "$RECORD" 2>/dev/null)"
{
  printf '%s\n' "$REPO_URL"
  {
    printf '%s\n' "$PREV"
    for p in $NEW_PKGS; do printf 'pkg:%s\n' "$p"; done
  } | grep -E '^(pkg|pip):' | sort -u
} > "$RECORD.tmp" && mv "$RECORD.tmp" "$RECORD"
hash -r 2>/dev/null

FOUND="$(command -v media-converter 2>/dev/null)"
if [ -n "$FOUND" ] && [ "$FOUND" != "$BIN" ]; then
  printf '%s! Another media-converter comes first in PATH: %s%s\n' "$C_R" "$FOUND" "$C_0"
  printf '  Delete it so the new one is used:  rm %s\n' "$FOUND"
fi

printf '%s✔ Installed%s %s\n' "$C_G" "$C_0" "${REMOTE_VERSION:+($REMOTE_VERSION)}"

if [ -d "$SRC_DIR/.git" ] && [ "$(basename "$SRC_DIR")" = "media-converter-cli" ]; then
  cd "$HOME" 2>/dev/null && rm -rf "$SRC_DIR" 2>/dev/null
fi

printf '\n%s✔ Done!%s Run:  %smedia-converter%s\n' "$C_G" "$C_0" "$C_B" "$C_0"
printf 'Help: media-converter --help   |   Uninstall: media-converter --remove\n'
printf 'If "command not found" appears, run: exec $SHELL\n\n'
