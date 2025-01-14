#!/bin/bash

# Description: show dimensions of all .mp4 videos under

set -euo pipefail

getdimensions() {
    video="$1"
    dimensions="$(ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 "${video}" | head -1)"
    printf '%5dx%-4d\t'"'"'%s'"'"'\n' \
        "${dimensions%x*}" \
        "${dimensions#*x}" \
        "${video#*/}"
}
export -f getdimensions

(($# == 1)) && {
    getdimensions "$1"
    exit 0
}

find . -regextype egrep -iregex '.*(mp4|webm|mkv)' -print0 | sort -zn |
    xargs -I{} -n1 -0 -P2 -r \
        bash -c 'getdimensions "{}"'
