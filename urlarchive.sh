#!/bin/sh

set -eu

err() { echo "ERROR:" >&2; }
usage() {
	cat <<EOF
Tries to get the snapshot from archive.is.
Usage:
    $(basename $0) URL
EOF
}

[ $# -ne 1 ] && usage && exit 1

BASE='https://archive.is/timegate'
URL="${1%#*}" # remove url fragments

curl -Ls -o /dev/null -w '%{http_code} %{url_effective}\n' "${BASE}/${URL}" |
	while read -r code effectiveurl; do
		case "${code}" in
		404)
			err "No archived :("
			exit 1
			;;
		*)
			echo "STATUS: ${code}"
			echo "URL: ${effectiveurl}"
			;;
		esac
	done
