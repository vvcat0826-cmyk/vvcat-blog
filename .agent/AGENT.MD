# HugoBlog — Agent 说明

本仓库用于搭建基于 [Hugo](https://gohugo.io/) 与 [hugo-theme-spectra](https://github.com/JoeYang1412/hugo-theme-spectra) 的个人博客（简体中文 + 英文，Hugo Module）。

执行建站、拉取主题、`hugo mod get`、从 GitHub 下载 exampleSite 等任务时，请遵循项目根目录的建站计划（`.cursor/plans` 或对话中确认的方案）。

## 网络与代理

本机已配置 HTTP/HTTPS 代理（常见于 Clash 等工具）。**当命令出现超时、连接被拒绝、无法解析 GitHub / proxy.golang.org 等网络问题时**，在当前 Shell 会话中启用代理后再重试，**不要**修改全局 `git config`。

代理地址：

| 项 | 值 |
|----|-----|
| HTTP/HTTPS 代理 | `http://127.0.0.1:7890` |

### PowerShell（推荐，仅当前会话）

```powershell
$env:HTTP_PROXY  = "http://127.0.0.1:7890"
$env:HTTPS_PROXY = "http://127.0.0.1:7890"
$env:ALL_PROXY   = "http://127.0.0.1:7890"
```

验证代理是否生效（可选）：

```powershell
curl -I https://github.com
```

### 常见需走代理的操作

- `hugo mod get` / `hugo mod tidy`（拉取 Go module 与主题）
- `go` 下载 module（`GOPROXY` 默认为 `https://proxy.golang.org`，若仍失败可临时设 `GOPROXY=https://goproxy.cn,direct` 并保留上述代理）
- `git clone` / `git fetch`（若用 HTTPS 克隆主题或 exampleSite）
- 用 `curl` / `Invoke-WebRequest` 下载 GitHub 上的 exampleSite 资源

### 注意事项

- 代理仅在本机 `127.0.0.1:7890` 监听且客户端已开启「系统代理」或 TUN 时有效；若仍失败，请确认本机代理软件已运行。
- 执行完联网步骤后，无需刻意清除环境变量；新开终端则不会继承。
- CI（GitHub Actions 等）一般**不要**使用该地址；在 CI 中依赖官方网络或平台提供的缓存即可。

## 环境要求（建站时）

- **Hugo Extended** ≥ v0.157.0（主题 SCSS / Hugo Pipes）
- **Go**（Hugo Module）
- 工作目录：本仓库根目录（clone 后的 `HugoBlog/`）

## 命令习惯

- 本地预览：`hugo server -D`
- 生产构建：`hugo --minify`
- 输出目录：`public/`（勿提交，应在 `.gitignore` 中）

## Cloudflare Pages 部署（东篱博客）

### 方式 A：Dashboard 连接 GitHub（与建站计划一致）

1. 推送本仓库到 GitHub（分支 `master`）。
2. [Cloudflare Dashboard](https://dash.cloudflare.com/) → **Workers & Pages** → **Create** → **Pages** → **Connect to Git** → 选仓库。
3. 构建设置：

| 项 | 值 |
|----|-----|
| Production branch | `master` |
| Build command | `bash scripts/cf-pages-build.sh`（脚本内默认 `HUGO_VERSION=0.167.0`、`GO_VERSION=1.22.0`） |
| Build output directory | `public` |

4. **Environment variables**（Production / Preview）：

| 变量 | 值 |
|------|-----|
| `HUGO_VERSION` | `0.167.0` |
| `GO_VERSION` | `1.22.0` |

5. CF Pages 项目名（如 `vvcat-blog`）；默认 `*.pages.dev` 可能与项目名不一致，以 Dashboard 为准。

**当前线上**

| 项 | 地址 |
|----|------|
| GitHub | https://github.com/vvcat0826-cmyk/vvcat-blog |
| Pages 生产 | https://vvcat.space/（备用 https://dongli-blog.pages.dev/） |
| CF 项目名 | `vvcat-blog`（生产分支 `master`） |

首次已用 Wrangler 直传部署。若要让 **push 自动构建**，请在 Cloudflare 该项目 **Settings → Builds** 中 **Connect to Git** 选上述仓库，并填与上表相同的 Build command / 环境变量（或配置 GitHub Secrets 走 workflow）。

### 方式 B：GitHub Actions（仓库内已含 workflow）

见 [`.github/workflows/cloudflare-pages.yml`](.github/workflows/cloudflare-pages.yml)。在 GitHub 仓库 **Settings → Secrets** 配置：

- `CLOUDFLARE_API_TOKEN`
- `CLOUDFLARE_ACCOUNT_ID`

推送 `master` 后自动构建部署；`CF_PAGES_PROJECT` 为 `vvcat-blog`，与 Pages 项目名一致即可。

### 验收

- 首页、双语、暗色模式正常
- `/index.json` 可访问（搜索）
- `/index.xml` 中链接为 `pages.dev`，非 `localhost`

## R2 图床（Cloudflare）

| 项 | 值 |
|----|-----|
| 桶名 | `dongli-blog-resources` |
| Account ID | 仅写在本地 `.env` 的 `CLOUDFLARE_ACCOUNT_ID`（Dashboard 右侧栏可查；勿提交 Git） |
| 生产 CDN（待绑定） | `https://img.example.com` → 换成真实 `img.<你的域名>`（与 `hugo.toml` 的 `params.imageCDN` 一致） |
| 临时 r2.dev 基址 | 仅记在本地 `.env` 的 `IMG_CDN_BASE`（勿提交 Git；长期用自定义域） |
| 文档 | [`docs/r2-image-hosting.md`](../docs/r2-image-hosting.md)、[`docs/cloudflare-cache-rules-img-cdn.md`](../docs/cloudflare-cache-rules-img-cdn.md) |
| 上传脚本 | [`scripts/upload-image.ps1`](../scripts/upload-image.ps1) |
| 绑域脚本 | [`scripts/r2-connect-custom-domain.ps1`](../scripts/r2-connect-custom-domain.ps1)（需 Cloudflare **Zone ID**） |

**不要**把 R2 API Token / `.env` 提交到 Git。复制 [`config/r2.example.env`](../config/r2.example.env) 为根目录 `.env`，设置 `IMG_CDN_BASE`。

自定义域绑定后：

1. 运行 `.\scripts\r2-connect-custom-domain.ps1 -ZoneId ... -Domain img.<域名>`
2. 按 `docs/cloudflare-cache-rules-img-cdn.md` 配置 Cache Rules
3. 更新 [`hugo.toml`](../hugo.toml) 的 `params.imageCDN`（文章内 R2 图可用相对路径，见 `render-image.html`）
4. （可选）在 R2 控制台关闭 r2.dev 公网访问，仅保留自定义域
