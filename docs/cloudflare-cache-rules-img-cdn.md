# img 子域 Cache Rules（R2 图床 CDN）

在自定义域名 **`img.example.com`** 已绑定到 R2 桶 `dongli-blog-resources` 且 SSL 为 **Active** 后配置。

## 创建规则

1. [Cloudflare Dashboard](https://dash.cloudflare.com/) → **Websites** → 选择根域 `example.com`。
2. **Rules** → **Cache Rules** → **Create rule**。
3. **Rule name**：`R2 images long cache`
4. **When incoming requests match**（示例）：
   - Field: **Hostname** → Operator: **equals** → Value: `img.example.com`
   - **And**
   - Field: **URI Path** → Operator: **matches wildcard** → Value: `*.webp`  
     （可再复制条件添加 `*.jpg`、`*.png`、`*.avif`，或用一个更宽的 `*` 若仅该子域只放图）
5. **Then**：
   - **Cache eligibility**: Eligible for cache
   - **Edge cache TTL**: Ignore cache-control and use this TTL → **1 month** 或 **1 year**
   - （可选）**Browser cache TTL**: 1 week
6. **Deploy** / **Save**。

## 与上传元数据配合

上传时建议带（`scripts/upload-image.ps1` 已默认设置）：

```http
Cache-Control: public, max-age=31536000, immutable
```

## 验证

1. 浏览器打开一张图 URL，开发者工具 → Network → 响应头。
2. 刷新两次，查看 **`cf-cache-status`**：第二次常为 `HIT`。
3. 若始终 `MISS`：确认 DNS 记录为 **Proxied（橙云）**，且规则 Hostname 与访问域名一致。

完整图床流程见 [r2-image-hosting.md](r2-image-hosting.md)。
