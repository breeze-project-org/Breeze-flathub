# Breeze Flatpak 源 (GitHub 托管)

给 Breeze 用的可更新 Flatpak remote，对齐 Homebrew tap 体验：加一次源，之后 `flatpak update` 即可跟随 Breeze Release 更新。

> 现状：Breeze Release 只提供单文件 `breeze-*.flatpak`，手动 `flatpak install` 装完后与源无关联，`flatpak update` 永远收不到更新。本仓库把每个 Release 的 bundle 导入为 ostree 仓库，通过 GitHub Pages 对外提供，解决更新通道问题。

- 应用 ID：`io.github.windy.breeze`
- 源地址：`https://deretame.github.io/Breeze-flathub/repo/`
- 同步策略：每天定时检查 [Breeze Release](https://github.com/deretame/Breeze/releases)，有新版自动导入（见 `.github/workflows/sync.yml`，也可手动触发并指定版本号）

## 一键安装

```bash
curl -fsSL https://raw.githubusercontent.com/deretame/Breeze-flathub/main/install.sh | bash
```

## 手动安装

```bash
# 1. 添加软件源（只需一次）
flatpak remote-add --user --if-not-exists breeze \
  https://raw.githubusercontent.com/deretame/Breeze-flathub/main/breeze.flatpakrepo

# 2. 安装 Breeze
flatpak install --user -y breeze io.github.windy.breeze
```

> 需要先配好 Flatpak 基础环境（各发行版见 [Flathub 快速设置](https://flathub.org/zh-Hans/setup)）；
> GNOME 50 Runtime 会随安装自动拉取。

## 更新

```bash
# 只更新 Breeze
flatpak update --user io.github.windy.breeze

# 或更新本源上所有应用
flatpak update --user
```

## 运行

```bash
flatpak run io.github.windy.breeze
```

## 卸载

```bash
flatpak uninstall --user io.github.windy.breeze
flatpak remote-delete --user breeze
```

## 仓库维护

- 首次启用：仓库 Settings → Pages → Source 选 `gh-pages` 分支（`/` 根目录），然后手动跑一次 `Sync Breeze Flatpak bundle` workflow。
- 每次同步导入 Release 的 `breeze-*.flatpak`，生成静态增量（static deltas）后推送到 `gh-pages` 分支，`main` 分支只存脚本与配置。
- `VERSION` 文件（位于 Pages 根目录）记录当前已导入的 Breeze 版本号。
