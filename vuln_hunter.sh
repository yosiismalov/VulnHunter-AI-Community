#!/usr/bin/env bash

set -uo pipefail

DOMAIN="${1:-}"

if [[ -z "$DOMAIN" ]]; then
    echo "Usage: ./vuln_hunter.sh domain.com"
    exit 1
fi

if [[ ! "$DOMAIN" =~ ^([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}$ ]]; then
    echo "Invalid domain: $DOMAIN"
    exit 1
fi

export PATH="$PATH:$HOME/go/bin"

OUT="output/$DOMAIN"
mkdir -p "$OUT" reports

echo
echo "========================================"
echo " VulnHunter-AI Community Edition"
echo "========================================"
echo "[*] Target: $DOMAIN"
echo

run_module() {
    local name="$1"
    local script="$2"

    if [[ ! -f "$script" ]]; then
        echo "[-] Missing module: $script"
        return 1
    fi

    echo "[*] Running: $name"

    if bash "$script" "$DOMAIN"; then
        echo "[+] Completed: $name"
    else
        echo "[-] Module failed: $name"
    fi

    echo
}

run_module "Reconnaissance" "recon/recon.sh"
run_module "JavaScript Analysis" "analyzers/js.sh"
run_module "GraphQL Detection" "analyzers/graphql.sh"
run_module "Header Analysis" "analyzers/headers.sh"
run_module "API Inventory" "analyzers/api_inventory.sh"
run_module "Report Generation" "reports/report.sh"

echo "========================================"
echo " Scan completed"
echo "========================================"
echo "[+] Output: $OUT"
echo "[+] Report: reports/${DOMAIN}_report.md"
echo
echo "Community Edition"
echo "Pro Edition: https://yosiismalov.gumroad.com/l/vulnhunter-ai-pro"
