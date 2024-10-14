#!/bin/bash

set -euo pipefail

warn() { printf "WARNING: %s\n\n" "$*" >&2; }
err() { printf "ERROR: %s\n" "$*" >&2; }
usage() {
	cat >&2 <<EOF
Returns a snapshot URL for the URL provided.

Usage:
    $(basename $0) <URL> [LATEST]

Options:
  <URL>    the url to lookup
  LATEST   flag, if present returns latest snapshot url

Uses the WaybackMachine JSON API (https://archive.org/help/wayback_api.php)
EOF
}

(($# < 1)) && usage && exit 22 # EINVAL
(($# > 1)) && TIMESTAMP='' || TIMESTAMP='19960101'

URL=${1%#*}     # remove fragment
URL=${URL#*://} # remove proto

curl -fGs -d "timestamp=${TIMESTAMP}" --data-urlencode "url=${URL}" 'http://archive.org/wayback/available' |
	jq -r '.archived_snapshots.closest | .status + " " + .url' |
	while read -r status url; do
		case "${status}" in
		200) echo "${url}" ;;
		"")
			err "no snapshot found for url :("
			exit 61 # ENODATA
			;;
		*)
			warn "found snapshot has http code ${status}"
			echo "${url}"
			;;
		esac
	done
