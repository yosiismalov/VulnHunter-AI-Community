#!/bin/bash

DOMAIN=$1
OUT="output/$DOMAIN"

echo "[*] GraphQL detection"

grep -Ei 'graphql|/gql|graph' "$OUT/all_urls.txt" 2>/dev/null \
| sort -u > "$OUT/graphql_candidates.txt"

> "$OUT/graphql_confirmed.txt"

head -100 "$OUT/graphql_candidates.txt" | while read -r url
do
    [[ -z "$url" ]] && continue

    body=$(curl -sk --max-time 8 \
        -H 'content-type: application/json' \
        --data '{"query":"{__typename}"}' \
        "$url")

    echo "$body" | grep -Eqi '__typename|errors|graphql' && echo "$url" >> "$OUT/graphql_confirmed.txt"
done

sort -u "$OUT/graphql_confirmed.txt" -o "$OUT/graphql_confirmed.txt"

echo "[+] GraphQL confirmed: $(wc -l < "$OUT/graphql_confirmed.txt" 2>/dev/null)"
