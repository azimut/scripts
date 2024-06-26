#!/bin/sh -eu

# See: https://archive.org/help/wayback_api.php

err() { printf "ERROR: %s\n\n" "$*" >&2; }
usage() {
	echo "Returns a snapshot for the URL provided, from the WaybackMachine."
	echo "Defaults to given the oldest available."
	echo
	echo "Usage:"
	printf '\t%s URL [ NEW? ]\n' "$(basename $0)"
}

[ $# -lt 1 ] && err "missing URL argument" && usage && exit 1
[ $# -gt 1 ] && TIMESTAMP='' || TIMESTAMP='&timestamp=19960101'

curl -s "http://archive.org/wayback/available?url=${1%#*}${TIMESTAMP}" |
	jq -r '.archived_snapshots.closest | .status + " " + .url'
