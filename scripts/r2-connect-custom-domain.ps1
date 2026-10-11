# Connect img.<your-domain> to R2 bucket (run after zone is Active on Cloudflare).
# Usage:
#   .\scripts\r2-connect-custom-domain.ps1 -ZoneId <zone_id> -Domain img.example.com

param(
    [Parameter(Mandatory = $true)]
    [string]$ZoneId,
    [Parameter(Mandatory = $true)]
    [string]$Domain,
    [string]$Bucket = "dongli-blog-resources"
)

$ErrorActionPreference = "Stop"
Write-Host "Connecting $Domain to bucket $Bucket (zone $ZoneId) ..."
npx --yes wrangler@3 r2 bucket domain add $Bucket --domain $Domain --zone-id $ZoneId -y
Write-Host "Done. Wait for SSL Active, then set IMG_CDN_BASE=https://$Domain in .env"
