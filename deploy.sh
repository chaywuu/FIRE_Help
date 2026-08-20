#!/bin/bash
set -e

# ===== 配置 =====
DEPLOY_DIR="/home/ubuntu/myproject/FIRE_Help"
DIST_DIR="$DEPLOY_DIR/docs/.vitepress/dist"
TMP_DIR="$DEPLOY_DIR/docs/.vitepress/dist.tmp"
BACKUP_DIR="$DEPLOY_DIR/docs/.vitepress/dist.bak"
REQUIRED_NODE_VERSION=18

# ===== 日志带时间戳 =====
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# ===== 失败回滚 =====
rollback() {
    log "❌ 部署失败，正在回滚..."
    # 清理临时构建目录
    if [ -d "$TMP_DIR" ]; then
        rm -rf "$TMP_DIR"
        log "已清理临时构建目录"
    fi
    # 恢复备份
    if [ -d "$BACKUP_DIR" ]; then
        if [ -d "$DIST_DIR" ]; then
            rm -rf "$DIST_DIR"
        fi
        mv "$BACKUP_DIR" "$DIST_DIR"
        log "✅ 已回滚到上一版本"
    else
        log "⚠️ 无可用备份（可能是首次部署）"
    fi
    exit 1
}
trap rollback ERR

# ===== 前置检查 =====
log "==> 检查 Node 版本"
NODE_VERSION=$(node -v | sed 's/v//' | cut -d. -f1)
if [ "$NODE_VERSION" -lt "$REQUIRED_NODE_VERSION" ]; then
    log "❌ Node 版本过低（当前 $NODE_VERSION，需要 ≥ $REQUIRED_NODE_VERSION）"
    exit 1
fi
log "✅ Node 版本: $(node -v)"

log "==> 检查部署目录"
if [ ! -d "$DEPLOY_DIR/.git" ]; then
    log "❌ 部署目录不存在或非 git 仓库：$DEPLOY_DIR"
    log "    请先执行：cd /home/ubuntu/myproject && git clone git@github.com:chaywuu/FIRE_Help.git FIRE_Help"
    exit 1
fi

cd "$DEPLOY_DIR"

# ===== 拉取最新代码 =====
log "==> 拉取最新代码"
git fetch origin main
git reset --hard origin/main
log "当前 commit: $(git rev-parse --short HEAD)"

# ===== 清理可能残留的临时目录 =====
if [ -d "$TMP_DIR" ]; then
    log "==> 清理残留的临时构建目录"
    rm -rf "$TMP_DIR"
fi

# ===== 安装依赖 =====
log "==> 安装依赖（npm ci）"
npm ci

# ===== 构建到临时目录 =====
log "==> 构建项目到临时目录"
# 使用 vitepress 的 --outDir 参数输出到临时目录，避免构建期间影响线上服务
npx vitepress build docs --outDir docs/.vitepress/dist.tmp

# 验证临时构建产物
if [ ! -f "$TMP_DIR/index.html" ]; then
    log "❌ 构建失败：临时目录中 index.html 不存在"
    exit 1
fi
log "✅ 构建产物验证通过"

# ===== 原子替换 =====
log "==> 备份当前 dist"
if [ -d "$DIST_DIR" ]; then
    rm -rf "$BACKUP_DIR"
    mv "$DIST_DIR" "$BACKUP_DIR"
fi

log "==> 替换为新构建产物"
mv "$TMP_DIR" "$DIST_DIR"

# ===== 最终验证 =====
log "==> 验证最终产物"
if [ -f "$DIST_DIR/index.html" ]; then
    log "✅ 部署成功，产物清单："
    ls -la "$DIST_DIR/" | head -20
else
    log "❌ 部署失败：$DIST_DIR/index.html 不存在"
    rollback
fi

# ===== 清理临时备份（保留最近一次以便回滚） =====
log "==> 部署完成"
log "    产物路径: $DIST_DIR"
log "    备份路径: $BACKUP_DIR（如需回滚：mv $BACKUP_DIR $DIST_DIR）"
