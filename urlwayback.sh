#!/bin/sh -eu

# Description: Returns the oldest url available
# See: https://archive.org/help/wayback_api.php

err() { echo "[ERROR]: $*" >&2; }
usage() {
	echo "Usage:"
	printf '\t%s URL [ NEW? ]\n' "$(basename $0)"
}

[ $# -lt 1 ] && err "missing URL argument" && usage && exit 1
[ $# -gt 1 ] && TIMESTAMP='' || TIMESTAMP='&timestamp=19960101'

curl -s "http://archive.org/wayback/available?url=${1%#*}${TIMESTAMP}" |
	jq -r '.archived_snapshots.closest | .status + " " + .url'
