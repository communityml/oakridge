#!/usr/bin/env bash
# deploy.sh — Upload index.html, donate.html, and img/ to S3, then invalidate CloudFront.
#
# Prerequisites:
#   - AWS CLI installed and configured (aws configure, or IAM role, or env vars)
#
# Usage:
#   ./deploy.sh            — deploy everything
#   ./deploy.sh --dry-run  — show what would be uploaded without doing it

set -euo pipefail

# ── Config ─────────────────────────────────────────────────────────────────────
BUCKET="www-oakridge-reignited"
DIST_ID="E3RV0FEEMEEB0Z"
REGION="us-west-2"
S3_PREFIX="origin/"
DOCS="docs"

DRY_RUN=false
if [[ "${1:-}" == "--dry-run" ]]; then
  DRY_RUN=true
  echo "=== DRY RUN — no changes will be made ==="
fi

# ── Helpers ────────────────────────────────────────────────────────────────────
upload() {
  local src="$1" dest="${S3_PREFIX}$2" ctype="$3"
  echo "  upload: $src → s3://$BUCKET/$dest"
  if ! $DRY_RUN; then
    aws s3 cp "$src" "s3://$BUCKET/$dest" \
      --content-type "$ctype" \
      --region "$REGION"
  fi
}

sync_dir() {
  local src="$1" dest="${S3_PREFIX}$2"
  echo "  sync:   $src → s3://$BUCKET/$dest"
  if ! $DRY_RUN; then
    aws s3 sync "$src" "s3://$BUCKET/$dest" \
      --region "$REGION" \
      --delete
  fi
}

# ── Preflight checks ───────────────────────────────────────────────────────────
echo "Checking source files..."
for f in "$DOCS/index.html" "$DOCS/donate.html"; do
  if [ ! -f "$f" ]; then
    echo "ERROR: $f not found. Promote a preview version to this path first."
    exit 1
  fi
done

# ── Upload ─────────────────────────────────────────────────────────────────────
echo ""
echo "Uploading to s3://$BUCKET/${S3_PREFIX} ..."
upload "$DOCS/index.html"  "index.html"  "text/html; charset=utf-8"
upload "$DOCS/donate.html" "donate.html" "text/html; charset=utf-8"
sync_dir "$DOCS/img" "img"

# ── CloudFront invalidation ────────────────────────────────────────────────────
# Invalidation paths are the public URL paths CloudFront serves,
# regardless of any S3 prefix configured in the origin.
echo ""
echo "Invalidating CloudFront distribution $DIST_ID ..."
if ! $DRY_RUN; then
  # MSYS_NO_PATHCONV=1 prevents Git Bash on Windows from mangling /paths into Windows paths
  MSYS_NO_PATHCONV=1 aws cloudfront create-invalidation \
    --distribution-id "$DIST_ID" \
    --paths "/index.html" "/donate.html" "/img/*" \
    --query 'Invalidation.{Id:Id,Status:Status}' \
    --output table
fi

echo ""
echo "Done. Changes should be live within ~30 seconds."
