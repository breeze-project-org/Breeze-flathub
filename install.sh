#!/usr/bin/env bash
# Breeze Flatpak 一键安装：添加软件源并安装/更新到最新版。
set -euo pipefail

REMOTE_NAME="${BREEZE_REMOTE:-breeze}"
FLATPAKREPO_URL="${BREEZE_FLATPAKREPO_URL:-https://raw.githubusercontent.com/deretame/Breeze-flathub/main/breeze.flatpakrepo}"
APP_ID="${BREEZE_APP_ID:-io.github.windy.breeze}"

if ! command -v flatpak >/dev/null 2>&1; then
  echo "未找到 flatpak，请先按 https://flathub.org/zh-Hans/setup 配好 Flatpak 环境。" >&2
  exit 1
fi

flatpak remote-add --user --if-not-exists "$REMOTE_NAME" "$FLATPAKREPO_URL"
flatpak install --user -y "$REMOTE_NAME" "$APP_ID"

echo "安装完成，运行：flatpak run $APP_ID"
