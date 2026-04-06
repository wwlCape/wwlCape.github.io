# =============================================================================
# Gemfile — Jekyll 4.x 现代化版本
# 兼容 Ruby 3.1+ / 4.x，完全移除 github-pages 元包及其旧依赖链
# 使用 rouge 替代 pygments.rb，使用 sass-embedded 替代旧版 sass
# =============================================================================

source "https://rubygems.org"

# ── Jekyll 核心 ──────────────────────────────────────────────────────────────
# Jekyll 4.x 原生支持 Ruby 3.x / 4.x，无需 github-pages 元包
gem "jekyll", "~> 4.3"

# ── Sass 编译器（现代版，替换旧 sass 3.x）────────────────────────────────────
# sass-embedded 基于 Dart Sass，完全兼容 Ruby 4.x，无需编译 C 扩展
gem "jekyll-sass-converter", "~> 3.0"

# ── 代码高亮（rouge 替代 pygments.rb）────────────────────────────────────────
# rouge 是纯 Ruby 实现，不需要任何 C 扩展或 Python 依赖
gem "rouge", "~> 4.0"

# ── Markdown 解析 ────────────────────────────────────────────────────────────
gem "kramdown", "~> 2.4"
gem "kramdown-parser-gfm", "~> 1.1"

# ── 本地开发服务器 ────────────────────────────────────────────────────────────
gem "webrick", "~> 1.8"

# ── Windows 平台专属（macOS/Linux 可忽略）────────────────────────────────────
gem "wdm", "~> 0.1" if Gem.win_platform?
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

# ── Jekyll 插件 ──────────────────────────────────────────────────────────────
group :jekyll_plugins do
  # _config.yml plugins: 列表中声明的插件，必须全部在此列出
  gem "jekyll-paginate",      "~> 1.1"   # 分页（_config.yml 要求）
  gem "jekyll-sitemap",       "~> 1.4"   # 站点地图
  gem "jekyll-gist",          "~> 1.5"   # Gist 嵌入（_config.yml 要求）
  gem "jekyll-feed",          "~> 0.17"  # RSS Feed
  gem "jekyll-redirect-from", "~> 0.16"  # 页面重定向

  # SEO 优化
  gem "jekyll-seo-tag",       "~> 2.8"

  # 相对链接自动处理
  gem "jekyll-relative-links", "~> 0.6"

  # Emoji 支持（_config.yml whitelist 中有 jemoji，按需启用）
  # gem "jemoji", "~> 0.13"
end
