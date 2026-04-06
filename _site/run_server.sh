#!/usr/bin/env bash
# =============================================================================
# run_server.sh — Jekyll 本地开发服务器启动脚本
# 兼容 Ruby 3.x / 4.x，含自动环境修复逻辑
# =============================================================================

set -euo pipefail

# ── 颜色输出 ──────────────────────────────────────────────────────────────────
RED='\033[0;31m'; YELLOW='\033[1;33m'; GREEN='\033[0;32m'; NC='\033[0m'
info()  { echo -e "${GREEN}[INFO]${NC}  $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC}  $*"; }
error() { echo -e "${RED}[ERROR]${NC} $*"; }

# ── 切换到脚本所在目录 ────────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"
info "工作目录: $SCRIPT_DIR"

# =============================================================================
# 1. Ruby 版本检测与自动降级
# =============================================================================
RUBY_CMD="ruby"
RUBY_VERSION=$("$RUBY_CMD" -e 'puts RUBY_VERSION' 2>/dev/null || echo "0.0.0")
RUBY_MAJOR=$(echo "$RUBY_VERSION" | cut -d. -f1)
RUBY_MINOR=$(echo "$RUBY_VERSION" | cut -d. -f2)

info "当前 Ruby 版本: $RUBY_VERSION"

# Jekyll 4.x 需要 Ruby >= 2.7；Ruby 4.x 完全兼容
if [ "$RUBY_MAJOR" -lt 2 ] || { [ "$RUBY_MAJOR" -eq 2 ] && [ "$RUBY_MINOR" -lt 7 ]; }; then
  warn "Ruby $RUBY_VERSION 过旧（需要 >= 2.7），尝试自动切换..."

  # 尝试 rbenv
  if command -v rbenv &>/dev/null; then
    info "检测到 rbenv，尝试安装并切换到 Ruby 3.3.0..."
    rbenv install 3.3.0 --skip-existing
    rbenv local 3.3.0
    eval "$(rbenv init -)"
    RUBY_CMD="$(rbenv which ruby)"
    info "已切换到: $($RUBY_CMD --version)"

  # 尝试 rvm
  elif command -v rvm &>/dev/null; then
    info "检测到 rvm，尝试安装并切换到 Ruby 3.3.0..."
    rvm install 3.3.0
    rvm use 3.3.0
    RUBY_CMD="$(which ruby)"
    info "已切换到: $($RUBY_CMD --version)"

  # 尝试 mise（现代版本管理器）
  elif command -v mise &>/dev/null; then
    info "检测到 mise，尝试安装并切换到 Ruby 3.3.0..."
    mise install ruby@3.3.0
    mise local ruby 3.3.0
    RUBY_CMD="$(mise which ruby)"
    info "已切换到: $($RUBY_CMD --version)"

  else
    error "未找到 rbenv / rvm / mise，请手动安装 Ruby 3.x："
    echo "  Homebrew: brew install rbenv && rbenv install 3.3.0 && rbenv local 3.3.0"
    echo "  官网:     https://www.ruby-lang.org/zh_cn/downloads/"
    exit 1
  fi
fi

info "最终使用 Ruby: $($RUBY_CMD --version)"

# =============================================================================
# 2. 编译器环境变量（修复 C 扩展编译问题）
# =============================================================================

# macOS Xcode Command Line Tools 路径
XCODE_SDK="$(xcrun --show-sdk-path 2>/dev/null || true)"
if [ -n "$XCODE_SDK" ]; then
  export SDKROOT="$XCODE_SDK"
  info "SDK 路径: $SDKROOT"
fi

# 修复旧版 C 扩展在 Apple Clang 严格模式下的编译失败
# 主要针对: posix-spawn, eventmachine, http_parser.rb 等
export CFLAGS="-Wno-error=implicit-function-declaration \
               -Wno-error=incompatible-function-pointer-types \
               -Wno-error=int-conversion \
               ${CFLAGS:-}"

export CXXFLAGS="-Wno-error=deprecated-declarations ${CXXFLAGS:-}"

# Bundler 层面的构建参数（针对具体 gem 单独设置）
export BUNDLE_BUILD__POSIX_SPAWN="--with-cflags='-Wno-error=implicit-function-declaration'"
export BUNDLE_BUILD__EVENTMACHINE="--with-cflags='-Wno-error=implicit-function-declaration'"
export BUNDLE_BUILD__HTTP_PARSER_RB="--with-cflags='-Wno-error=implicit-function-declaration'"

# Homebrew OpenSSL（避免 openssl gem 找不到头文件）
if [ -d "/opt/homebrew/opt/openssl@3" ]; then
  export BUNDLE_BUILD__OPENSSL="--with-openssl-dir=/opt/homebrew/opt/openssl@3"
  export PKG_CONFIG_PATH="/opt/homebrew/opt/openssl@3/lib/pkgconfig:${PKG_CONFIG_PATH:-}"
elif [ -d "/usr/local/opt/openssl@3" ]; then
  export BUNDLE_BUILD__OPENSSL="--with-openssl-dir=/usr/local/opt/openssl@3"
  export PKG_CONFIG_PATH="/usr/local/opt/openssl@3/lib/pkgconfig:${PKG_CONFIG_PATH:-}"
fi

# =============================================================================
# 3. 安装依赖
# =============================================================================
BUNDLE_CMD="$($RUBY_CMD -e 'puts Gem.bindir')/bundle"
if [ ! -f "$BUNDLE_CMD" ]; then
  info "正在安装 Bundler..."
  "$RUBY_CMD" -S gem install bundler --quiet
  BUNDLE_CMD="$($RUBY_CMD -e 'puts Gem.bindir')/bundle"
fi

# 将 gem 安装在项目本地（避免污染系统 gem 目录）
if [ ! -d "vendor/bundle" ]; then
  info "首次运行，安装项目依赖（可能需要几分钟）..."
  "$BUNDLE_CMD" config set --local path 'vendor/bundle'
  "$BUNDLE_CMD" install
else
  info "检查依赖更新..."
  "$BUNDLE_CMD" install --quiet
fi

# =============================================================================
# 4. 启动 Jekyll 开发服务器
# =============================================================================
info "启动 Jekyll 服务器..."
echo ""
echo -e "${GREEN}  本地访问地址: http://127.0.0.1:4000${NC}"
echo -e "${GREEN}  按 Ctrl+C 停止服务器${NC}"
echo ""

# --livereload  实时重载（修改文件后浏览器自动刷新）
# --open-url    自动打开浏览器（可按需移除）
# --trace       出错时显示完整堆栈（调试用，稳定后可移除）
exec "$BUNDLE_CMD" exec jekyll serve \
  --livereload \
  --host 127.0.0.1 \
  --port 4000 \
  --trace
