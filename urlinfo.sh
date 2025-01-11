#!/bin/bash

set -euo pipefail

usage() {
    cat <<EOF
Returns each url Location jump for the given URL.

Usage:
    $(basename "$0") <URL>
EOF
}

(($# != 1)) && usage && exit 1

URL="$1"
echo "00: ${URL}"

i=0
torsocks curl -svo /dev/null -L "${URL}" 2>&1 | grep '^<' |
    while read -r _ field value; do
        case "${field,,}" in
        "location:") printf '%02d: %s\n' "$((++i))" "${value}" ;;
        "server:" | "date:" | "last-modified:") printf '%18s %s\n' "${field}" "${value}" ;;
        esac
    done
