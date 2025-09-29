#!/bin/bash
set -e

cd ~ || { echo "❌ 无法切换到主目录"; exit 1; }
USERNAME="$(basename "$PWD")"

read -p "请输入要卸载的域名（如 us.example.com）: " DOMAIN
[ -z "$DOMAIN" ] && { echo "❌ 域名不能为空"; exit 1; }

APP_ROOT="/home/$USERNAME/domains/$DOMAIN/public_html"
NODE_ENV_VERSION="22"

echo "🗑️ 开始卸载应用: $DOMAIN"

# ========== 删除 Node 环境 ==========
if [ -x ./cf ]; then
  echo "⚙️ 使用已有 cf 命令删除 Node 环境"
  ./cf destroy --json --interpreter=nodejs --user="$USERNAME" --app-root="$APP_ROOT" || true
else
  if [ -x /usr/sbin/cloudlinux-selector ]; then
    echo "⚙️ 使用系统 cloudlinux-selector 删除 Node 环境"
    /usr/sbin/cloudlinux-selector destroy --json --interpreter=nodejs --user="$USERNAME" --app-root="$APP_ROOT" || true
  else
    echo "⚠️ 未找到 cloudlinux-selector，跳过 Node 环境删除"
  fi
fi

# ========== 删除应用目录 ==========
if [ -d "$APP_ROOT" ]; then
  echo "🗑️ 删除目录: $APP_ROOT"
  rm -rf "$APP_ROOT"
else
  echo "📂 目录 $APP_ROOT 不存在，跳过"
fi

# ========== 清理 crontab ==========
echo "🧹 清理 crontab 任务"
crontab -l | grep -v "cron.sh" > ./mycron || true
crontab ./mycron || true
rm -f ./mycron

# ========== 删除 cron.sh ==========
if [ -f "/home/$USERNAME/cron.sh" ]; then
  echo "🗑️ 删除 cron.sh"
  rm -f "/home/$USERNAME/cron.sh"
fi

# ========== 完成 ==========
echo "✅ 卸载完成: $DOMAIN"
