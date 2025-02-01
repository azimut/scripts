#!/bin/bash
set -euo pipefail

usage() {
    echo -e "youtube-dl wrapper, with a fzf menu for selecting the url audio/video format combo.\n"
    echo -e "Usage:\n\t$(basename "$0") URL"
}
(($# != 2)) && usage && exit

formats="$(bkt --ttl 1h -- yt-dlp -F "$1" |
    grep '^[0-9]' |
    fzf -m2 |
    awk '{ print $1 } END { if (NR!=2) exit 1 }' |
    paste -sd+)"

set +x
mpv --ytdl-format="${formats}" "$1"
