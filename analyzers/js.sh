#!/bin/bash

DOMAIN=$1
OUT="output/$DOMAIN"

echo "[*] JS analysis"

grep -Ei '\.js($|\?)' "$OUT/all_urls.txt" 2>/dev/null \
| sort -u \
| head -300 \
> "$OUT/js_files.txt"

mkdir -p "$OUT/js_downloads"
> "$OUT/js_findings.txt"
> "$OUT/js_endpoints.txt"

while read -r url
do
    [[ -z "$url" ]] && continue

    file="$OUT/js_downloads/$(echo "$url" | sed 's#https\?://##;s#[/?&=:]#_#g').js"

    curl -sk --max-time 10 "$url" -o "$file"

    grep -HinE 'api|graphql|token|authorization|bearer|secret|firebase|s3|aws|client_id|redirect_uri|oauth|session' "$file" >> "$OUT/js_findings.txt" 2>/dev/null

    grep -Eo 'https?://[^"'\'' )]+' "$file" 2>/dev/null \
    | grep -Ei 'api|graphql|auth|login|token|webhook|admin|v1|v2|v3|oauth|session' \
    >> "$OUT/js_endpoints.txt"

done < "$OUT/js_files.txt"

sort -u "$OUT/js_endpoints.txt" -o "$OUT/js_endpoints.txt"

echo "[+] JS findings saved"
