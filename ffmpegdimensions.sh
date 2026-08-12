#!/bin/bash

# Description: show dimensions and duration of all .mp4 videos under $PWD

set -euo pipefail

getmetadata() {
    video="$1"
    ffprobe -v error -select_streams v:0 -show_entries stream=width,height,duration -of csv=s=,:p=0 "${video}" |
        while IFS=, read -r width height seconds; do
            duration="$(date --utc --date="@${seconds}" '+%H:%M:%S')"
            printf '%5dx%-4d\t%10s\t'"'"'%s'"'"'\n' \
                   "${width}" "${height}" "${duration}" "${video#*/}"
        done
}
export -f getmetadata

(($# == 1)) && {
    getmetadata "$1"
    exit 0
}

find . -regextype egrep -iregex '.*(mp4|webm|mkv)' -print0 |
    sort -zn |
    xargs -I{} -n1 -0 -P2 -r \
        bash -c 'getmetadata "{}"'
