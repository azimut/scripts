#!/bin/bash
set -euo pipefail

FFMPEG="${FFMPEG:-/usr/bin/ffmpeg}"

while true; do
    filter="$(
        "${FFMPEG}" -loglevel quiet -filters |
            tail +9 |
            fzf --tiebreak=begin |
            awk '{ print $2 }'
    )"
    "${FFMPEG}" -help filter="${filter}" 2>/dev/null |
        sed "1s/Filter/\t/;s/^${filter} AVOptions://" | less
done
