#!/bin/bash

DOMAIN=$1
OUT="output/$DOMAIN"

RAW="$OUT/api_inventory_raw.txt"
INV="$OUT/api_inventory.txt"

> "$RAW"
> "$INV"

cat "$OUT/all_urls.txt" 2>/dev/null >> "$RAW"
cat "$OUT/js_endpoints.txt" 2>/dev/null >> "$RAW"
cat "$OUT/graphql_candidates.txt" 2>/dev/null >> "$RAW"
cat "$OUT/graphql_confirmed.txt" 2>/dev/null >> "$RAW"

cat "$RAW" \
| sed 's/^ *//;s/ *$//' \
| grep -E '^https?://' \
| grep -Ei 'api|graphql|v1|v2|v3|auth|login|sso|account|cart|checkout|payment|order|webhook|admin|user|profile|tenant|token|oauth|session|entitlement|wallet' \
| grep -Eiv '\.(png|jpg|jpeg|gif|svg|webp|woff|woff2|ttf|ico|css|map|mp4|mp3|pdf)(\?|$)' \
| grep -Eiv 'blog|author|privacy|terms|user-agreement|youtube|facebook|twitter|instagram|linkedin|doubleclick|google|gstatic|cloudflare|fonts|example\.com' \
| sort -u \
| head -3000 \
> "$INV"

echo "[+] API inventory: $(wc -l < "$INV")"
