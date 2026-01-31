#!/bin/bash
set -euo pipefail

usage() {
    echo -e "Mono audio track from provided input video file.\n"
    echo -e "Usage:\n\t$ $(basename "$0") <VIDEO>"
}

(($# != 1)) && usage && exit 1
[[ ! -f $1 ]] && usage && exit 1

extension="${1##*.}"
outfile="mutedtmp.${extension}"

trap 'rm -f -- "'"${outfile}"'"' EXIT
ffmpeg -y -i "$1" -c:v copy -ac 1 "${outfile}"
mv "${outfile}" "$1"
