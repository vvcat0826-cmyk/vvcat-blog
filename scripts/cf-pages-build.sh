#!/usr/bin/env bash
# Cloudflare Pages build (set as Build command: bash scripts/cf-pages-build.sh)
# Pins Hugo/Go even when dashboard env vars are missing; CF Hugo image reads HUGO_VERSION when set.
set -euo pipefail

export HUGO_VERSION="${HUGO_VERSION:-0.167.0}"
export GO_VERSION="${GO_VERSION:-1.22.0}"

hugo mod get
hugo --minify --baseURL "${CF_PAGES_URL}/"
