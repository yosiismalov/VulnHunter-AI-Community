#!/bin/bash

DOMAIN=$1
OUT="output/$DOMAIN"

mkdir -p "$OUT"

echo "[*] Subdomain enumeration"

subfinder \
    -d "$DOMAIN" \
    -silent \
    -max-time 1 \
    -t 100 \
| grep -Eiv 'applebot|phobos|itunes|mzstatic|icloud-content|akadns|edgekey|edgesuite' \
| sort -u \
| head -3000 \
> "$OUT/subdomains.txt"

echo "[*] Live host probing"

httpx -l "$OUT/subdomains.txt" \
-silent \
-follow-host-redirects \
-timeout 5 \
-retries 1 \
-threads 100 \
-title \
-tech-detect \
-status-code \
-json \
> "$OUT/httpx.json"

jq -r '.url' "$OUT/httpx.json" 2>/dev/null \
| sort -u \
> "$OUT/live_hosts.txt"

echo "[*] URL collection"

gau "$DOMAIN" 2>/dev/null \
| grep -Eiv 'applebot|mzstatic|itunes.apple.com|apps.apple.com|music.apple.com|podcasts.apple.com' \
| head -5000 \
> "$OUT/gau.txt" &

katana \
-list "$OUT/live_hosts.txt" \
-silent \
-d 2 \
| head -5000 \
> "$OUT/katana.txt" &

wait

cat "$OUT/gau.txt" "$OUT/katana.txt" 2>/dev/null \
| grep -E '^https?://' \
| grep -Ev '\.(png|jpg|jpeg|gif|svg|webp|woff|woff2|ttf|ico)(\?|$)' \
| sort -u \
> "$OUT/all_urls.txt"

echo "[+] Recon done"
echo "Live hosts: $(wc -l < "$OUT/live_hosts.txt" 2>/dev/null)"
echo "URLs: $(wc -l < "$OUT/all_urls.txt" 2>/dev/null)"
