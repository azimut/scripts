#!/bin/bash
set -euo pipefail

usage() {
    echo -e "Removes audio track from provided input video file.\n"
    echo -e "Usage:\n\t$ $(basename "$0") <VIDEO>"
}

(($# != 1)) && usage && exit 1
[[ ! -f $1 ]] && usage && exit 1

trap 'rm -f -- mutedtmp.mp4' EXIT
ffmpeg -y -i "$1" -map 0 -map -0:a -c copy mutedtmp.mp4
mv mutedtmp.mp4 "$1"
