#!/usr/bin/env bash
# Breeze Flatpak 一键安装：添加软件源并安装/更新到最新版。
# 改动脚本时把 INSTALLER_VERSION +1，用户可凭此确认跑的不是 CDN 旧缓存。
INSTALLER_VERSION=5
set -euo pipefail
echo "Breeze installer v$INSTALLER_VERSION"

REMOTE_NAME="${BREEZE_REMOTE:-breeze}"
FLATHUB_REMOTE="${BREEZE_FLATHUB_REMOTE:-flathub-upstream}"
FLATHUB_URL="${BREEZE_FLATHUB_URL:-https://dl.flathub.org/repo/flathub.flatpakrepo}"
FLATPAKREPO_URL="${BREEZE_FLATPAKREPO_URL:-https://raw.githubusercontent.com/breeze-project-org/Breeze-flathub/main/breeze.flatpakrepo}"
REPO_URL="${BREEZE_REPO_URL:-https://breeze-project-org.github.io/Breeze-flathub/repo/}"
LEGACY_REPO_URL="${BREEZE_LEGACY_REPO_URL:-https://deretame.github.io/Breeze-flathub/repo/}"
APP_ID="${BREEZE_APP_ID:-io.github.windy.breeze}"
RUNTIME="${BREEZE_RUNTIME:-org.gnome.Platform//50}"

if ! command -v flatpak >/dev/null 2>&1; then
  echo "未找到 flatpak，请先按 https://flathub.org/zh-Hans/setup 配好 Flatpak 环境。" >&2
  exit 1
fi

if flatpak remotes --user --columns=name | grep -qx "$FLATHUB_REMOTE"; then
  flatpak remote-modify --user --no-filter "$FLATHUB_REMOTE" </dev/null
else
  flatpak remote-add --user "$FLATHUB_REMOTE" "$FLATHUB_URL" </dev/null
fi
flatpak remote-add --user --if-not-exists "$REMOTE_NAME" "$FLATPAKREPO_URL" </dev/null

# 仓库迁移：旧 GitHub Pages 地址已失效，自动把老用户已有的源修正到新地址。
CURRENT_REPO_URL="$(flatpak remotes --user --columns=name,url | awk -v n="$REMOTE_NAME" '$1 == n { print $2 }')"
if [ "$CURRENT_REPO_URL" = "$LEGACY_REPO_URL" ]; then
  echo "检测到旧软件源地址，迁移到 $REPO_URL"
  flatpak remote-modify --user --url="$REPO_URL" "$REMOTE_NAME" </dev/null
fi

flatpak install --user -y "$FLATHUB_REMOTE" "$RUNTIME" </dev/null
flatpak install --user -y "$REMOTE_NAME" "$APP_ID" </dev/null

echo "安装完成，运行：flatpak run $APP_ID"
