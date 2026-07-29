#!/usr/bin/env bash

set -uo pipefail

DOMAIN="${1:-}"

if [[ -z "$DOMAIN" ]]; then
    echo "Usage: bash reports/report.sh domain.com"
    exit 1
fi

OUT="output/$DOMAIN"
REPORT="reports/${DOMAIN}_report.md"

mkdir -p reports

count_lines() {
    local file="$1"

    if [[ -f "$file" ]]; then
        wc -l < "$file" | tr -d ' '
    else
        echo "0"
    fi
}

print_file_section() {
    local title="$1"
    local file="$2"
    local limit="${3:-200}"

    echo "## $title"
    echo

    if [[ -s "$file" ]]; then
        sed -n "1,${limit}p" "$file"
    else
        echo "No results."
    fi

    echo
}

{
    echo "# VulnHunter-AI Community Report"
    echo
    echo "## Target"
    echo
    echo "\`$DOMAIN\`"
    echo
    echo "## Scan Summary"
    echo
    echo "| Category | Results |"
    echo "|---|---:|"
    echo "| Subdomains | $(count_lines "$OUT/subdomains.txt") |"
    echo "| Live hosts | $(count_lines "$OUT/live_hosts.txt") |"
    echo "| Collected URLs | $(count_lines "$OUT/all_urls.txt") |"
    echo "| JavaScript files | $(count_lines "$OUT/js_files.txt") |"
    echo "| JavaScript endpoints | $(count_lines "$OUT/js_endpoints.txt") |"
    echo "| GraphQL candidates | $(count_lines "$OUT/graphql_candidates.txt") |"
    echo "| GraphQL responses | $(count_lines "$OUT/graphql_confirmed.txt") |"
    echo "| API inventory entries | $(count_lines "$OUT/api_inventory.txt") |"
    echo "| Header observations | $(count_lines "$OUT/header_findings.txt") |"
    echo
    echo "> Automated results are research leads and are not proof of a vulnerability."
    echo

    print_file_section "Live Hosts" "$OUT/live_hosts.txt" 300
    print_file_section "API Inventory" "$OUT/api_inventory.txt" 300
    print_file_section "GraphQL Candidates" "$OUT/graphql_candidates.txt" 200
    print_file_section "GraphQL Responses Requiring Manual Review" "$OUT/graphql_confirmed.txt" 200
    print_file_section "JavaScript Endpoints" "$OUT/js_endpoints.txt" 300
    print_file_section "Header Observations" "$OUT/header_findings.txt" 300

    echo "## Output Files"
    echo
    echo '```text'
    find "$OUT" -maxdepth 1 -type f -printf '%f\n' 2>/dev/null | sort
    echo '```'
    echo
    echo "## Manual Validation"
    echo
    echo "- Confirm that every tested asset is explicitly in scope."
    echo "- Review authentication and authorization manually."
    echo "- Treat missing headers as observations, not confirmed vulnerabilities."
    echo "- Validate GraphQL behavior before reporting."
    echo "- Do not report automated matches without a reproducible security impact."
    echo
    echo "## Upgrade"
    echo
    echo "VulnHunter-AI Pro adds advanced scoring, API ranking, attack-path generation, authentication-flow discovery, parameter intelligence, response fingerprinting, live API validation, AI-assisted analysis, and an HTML dashboard."
    echo
    echo "https://yosiismalov.gumroad.com/l/vulnhunter-ai-pro"
} > "$REPORT"

echo "[+] Final report: $REPORT"
