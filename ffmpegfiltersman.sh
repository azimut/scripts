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
    MANPAGER="less -p ^[[:space:]]{3}${filter}" man ffmpeg-filters
done
