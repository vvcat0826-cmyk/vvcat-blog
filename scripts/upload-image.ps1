# Upload a local image to R2 bucket dongli-blog-resources (override with R2_BUCKET in .env).
# Usage:
#   .\scripts\upload-image.ps1 -LocalPath .\photo.webp -ObjectKey posts/2026/my-post/cover.webp
# Requires: npx wrangler (logged in via wrangler login)

param(
    [Parameter(Mandatory = $true)]
    [string]$LocalPath,
    [Parameter(Mandatory = $true)]
    [string]$ObjectKey,
    [string]$Bucket = "",
    [string]$ContentType = "image/webp"
)

$ErrorActionPreference = "Stop"
if (-not $Bucket -and $env:R2_BUCKET) { $Bucket = $env:R2_BUCKET }
if (-not $Bucket) { $Bucket = "dongli-blog-resources" }
if (-not (Test-Path $LocalPath)) { throw "File not found: $LocalPath" }

$ObjectKey = $ObjectKey.TrimStart("/").Replace("\", "/")

$ext = [System.IO.Path]::GetExtension($LocalPath).ToLowerInvariant()
if ($ext -eq ".png") { $ContentType = "image/png" }
elseif ($ext -in ".jpg", ".jpeg") { $ContentType = "image/jpeg" }
elseif ($ext -eq ".avif") { $ContentType = "image/avif" }

$cache = 'public, max-age=31536000, immutable'

Write-Host "Uploading to $Bucket/$ObjectKey ..."
npx --yes wrangler@3 r2 object put "$Bucket/$ObjectKey" `
    --file $LocalPath `
    --content-type $ContentType `
    --cache-control $cache

$base = $env:IMG_CDN_BASE
if (-not $base) { $base = "https://img.example.com" }
$base = $base.TrimEnd("/")
Write-Host ""
Write-Host "Public URL (after custom domain is bound):"
Write-Host "  $base/$ObjectKey"
Write-Host ""
Write-Host "Use in Hugo front matter:"
Write-Host "  cover: `"$base/$ObjectKey`""
