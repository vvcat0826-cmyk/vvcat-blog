# Cloudflare Pages 构建（Hugo + Spectra）

## 必设项（Dashboard）

**Workers & Pages** → 项目 **`dongli-blog`** → **Settings** → **Builds & deployments**

| 项 | 值 |
|----|-----|
| Production branch | `master` |
| Build command | `bash scripts/cf-pages-build.sh` |
| Build output directory | `public` |
| Git 仓库 | `vvcat0826-cmyk/vvcat-blog` |

**Environment variables**（Production 与 Preview，可与脚本默认值一致）：

| 变量 | 值 |
|------|-----|
| `HUGO_VERSION` | `0.167.0` |
| `GO_VERSION` | `1.22.0` |

Spectra 需要 **Hugo Extended ≥ 0.157**；低于 0.156 时主题 `opengraph.html` 中的 `hugo.Sites` 会导致构建失败。本站已用 [`layouts/partials/head/opengraph.html`](../layouts/partials/head/opengraph.html) 覆盖并去掉仅用于 GitHub Pages 的 404 脚本。

## 本地对照

```bash
hugo mod get && hugo --minify --baseURL "https://dongli-blog.pages.dev/"
```
