#!/usr/bin/env bash

set -u

required=(
    subfinder
    httpx
    katana
    gau
    curl
    jq
    sha256sum
)

missing=0

echo "VulnHunter-AI dependency check"
echo

for tool in "${required[@]}"; do
    if command -v "$tool" >/dev/null 2>&1; then
        printf "[+] %-15s %s\n" "$tool" "$(command -v "$tool")"
    else
        printf "[-] %-15s missing\n" "$tool"
        missing=$((missing + 1))
    fi
done

echo

if (( missing > 0 )); then
    echo "[-] Missing dependencies: $missing"
    exit 1
fi

echo "[+] All required dependencies are installed"
