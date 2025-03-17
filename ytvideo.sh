#!/bin/bash
set -euo pipefail

usage() {
    echo -e "youtube-dl wrapper, with a fzf menu for selecting the url audio/video format combo.\n"
    echo -e "Usage:\n\t$(basename "$0") URL"
}
(($# != 1)) && usage && exit

formats="$(
    bkt --ttl 1h -- yt-dlp -F "$1" |
        grep '^[0-9]' |
        grep --color=always -e '^' -e 'video only' |
        fzf -m2 --ansi |
        awk '{ print $1 }' |
        paste -sd+
)"

set +x
exec mpv --ytdl-format="${formats}" "$1"
