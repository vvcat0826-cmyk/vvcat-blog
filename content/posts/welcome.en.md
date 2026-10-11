---
title: "Welcome"
date: 2026-10-08
draft: false
tags: [blog]
description: "The site is ready — time to write."
toc: false
---

This post demonstrates **R2-hosted images** (bucket `dongli-blog-resources`). Set `params.imageCDN` in `hugo.toml` to `https://img.yourdomain.com`, then reference objects with a relative path in Markdown.

![R2 test image](site/test.png)

See `docs/r2-image-hosting.md` and `scripts/upload-image.ps1` in the repo.

```powershell
hugo server -D
```
