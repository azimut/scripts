#!/bin/bash
set -euo pipefail

while true; do
    filter="$(
        ffmpeg -loglevel quiet -filters |
            tail +9 |
            fzf --tiebreak=begin |
            awk '{ print $2 }'
    )"
    ffmpeg -help filter="${filter}" 2>/dev/null |
        sed "1s/Filter/\t/;s/^${filter} AVOptions://" | less
done
