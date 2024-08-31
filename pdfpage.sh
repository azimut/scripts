#!/bin/bash

set -eu

err() { echo "ERROR: $*" >&2; }
usage() {
	cat <<EOF
Saves pdf PAGE as a png image.
Usage:
    $(basename $0) <PDF> <PAGE>
EOF
}

FILE="$1"
PAGE="$2"

[ $# -ne 2 ] && usage && exit 1
[ ! -s "${FILE}" ] && err "Given file does NOT exist." && exit 1
[[ ${FILE,,} != *pdf ]] && err "Given file is not a .pdf?" && exit 1

OUTPUT="${FILE}.${PAGE}"

pdftoppm "${FILE}" "${OUTPUT}" -png -f "${PAGE}" -singlefile
