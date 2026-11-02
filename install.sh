#!/usr/bin/env bash
# Breeze Flatpak 一键安装：添加软件源并安装/更新到最新版。
set -euo pipefail

REMOTE_NAME="${BREEZE_REMOTE:-breeze}"
FLATHUB_REMOTE="${BREEZE_FLATHUB_REMOTE:-flathub}"
FLATHUB_URL="${BREEZE_FLATHUB_URL:-https://dl.flathub.org/repo/flathub.flatpakrepo}"
FLATPAKREPO_URL="${BREEZE_FLATPAKREPO_URL:-https://raw.githubusercontent.com/deretame/Breeze-flathub/main/breeze.flatpakrepo}"
APP_ID="${BREEZE_APP_ID:-io.github.windy.breeze}"
RUNTIME="${BREEZE_RUNTIME:-org.gnome.Platform//50}"

if ! command -v flatpak >/dev/null 2>&1; then
  echo "未找到 flatpak，请先按 https://flathub.org/zh-Hans/setup 配好 Flatpak 环境。" >&2
  exit 1
fi

if flatpak remotes --user --columns=name | grep -qx "$FLATHUB_REMOTE"; then
  flatpak remote-modify --user --no-filter "$FLATHUB_REMOTE"
else
  flatpak remote-add --user "$FLATHUB_REMOTE" "$FLATHUB_URL"
fi
flatpak remote-add --user --if-not-exists "$REMOTE_NAME" "$FLATPAKREPO_URL"
flatpak install --user -y "$FLATHUB_REMOTE" "$RUNTIME"
flatpak install --user -y "$REMOTE_NAME" "$APP_ID"

echo "安装完成，运行：flatpak run $APP_ID"
