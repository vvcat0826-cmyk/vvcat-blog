---
title: "欢迎"
date: 2026-10-08
draft: false
tags: [博客]
description: "站点已就绪，可以开始写作了。"
toc: false
# 外链封面：Spectra 的 cover 请用相对路径或 Page Bundle；R2 图用正文 Markdown 相对路径 + hugo.toml 的 imageCDN。
---

你好，这是本站的第一篇文章。

图片存放在 **Cloudflare R2**（桶 `dongli-blog-resources`），通过 CDN 子域访问。在 `hugo.toml` 设置 `params.imageCDN` 为 `https://img.<你的域名>` 后，正文里用相对路径即可（见下图）。

![R2 图床测试图](site/test.png)

写新文章：

```powershell
hugo new content posts/你的标题.zh-cn.md
.\scripts\upload-image.ps1 -LocalPath .\图.webp -ObjectKey posts/2026/你的标题/cover.webp
```

本地预览：`hugo server -D`。图床说明见仓库 `docs/r2-image-hosting.md`。
