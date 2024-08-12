#!/bin/sh -eu

# See: https://archive.org/help/wayback_api.php

err() { printf "ERROR: %s\n\n" "$*" >&2; }
usage() {
	cat <<EOF
Returns a snapshot for the URL provided, from the WaybackMachine.
Defaults to given the oldest available.

Usage:
    $(basename $0) URL [ RECENT? ]
EOF
}

[ $# -lt 1 ] && err "missing URL argument" && usage && exit 22
[ $# -gt 1 ] && TIMESTAMP='' || TIMESTAMP='timestamp=19960101&'

URL=${1%#*}     # remove url fragments
URL=${URL#*://} # remove url proto

curl -s "http://archive.org/wayback/available?${TIMESTAMP}url=${URL}" |
	jq -r '.archived_snapshots.closest | .status + " " + .url' |
	while read -r status url; do
		case "${status}" in
		200) echo "${url}" ;;
		"")
			echo "ERROR: no snapshot found for url :(" >&2
			exit 61
			;;
		*)
			echo "WARNING: found snapshot has http code ${status}" >&2
			echo "${url}"
			;;
		esac
	done
