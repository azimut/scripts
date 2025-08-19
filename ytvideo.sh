#!/bin/bash
set -euo pipefail

usage() {
    echo -e "youtube-dl wrapper, with a fzf menu for selecting the url audio/video format combo.\n"
    echo -e "Usage:\n\t$(basename "$0") URL [START_TIME]}"
}
(($# < 1)) && usage && exit

start_time="${2:-}"

if [[ -n "${start_time}" ]]; then
    start_time="--start=${start_time}"
fi

formats="$(
    bkt --ttl 1h -- yt-dlp -F "$1" |
        grep '^[0-9]' |
        grep --color=always -e '^' -e 'video only' |
        fzf -m2 --ansi |
        awk '{ print $1 }' |
        paste -sd+
)"

set -x
exec mpv --ytdl-format="${formats}" ${start_time} "$1"
