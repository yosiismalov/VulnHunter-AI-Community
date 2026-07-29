#!/bin/bash

DOMAIN=$1
OUT="output/$DOMAIN"

echo "[*] Header analysis"

> "$OUT/header_findings.txt"

head -200 "$OUT/live_hosts.txt" | while read -r url
do
    [[ -z "$url" ]] && continue

    headers=$(curl -skI --max-time 6 "$url")

    echo "$headers" | grep -qi 'access-control-allow-origin: \*' && echo "[CORS-WILDCARD] $url" >> "$OUT/header_findings.txt"
    echo "$headers" | grep -qvi 'content-security-policy' && echo "[MISSING-CSP] $url" >> "$OUT/header_findings.txt"
    echo "$headers" | grep -qvi 'x-frame-options' && echo "[MISSING-XFO] $url" >> "$OUT/header_findings.txt"

done

echo "[+] Header findings saved"
