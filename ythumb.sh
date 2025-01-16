#!/bin/bash
set -eo pipefail

function usage() {
    cat <<EOF
Returns the thumbnails urls of the given youtube video.

    $(basename "$0") [URL]
EOF
}

(($# != 1)) && usage && exit 1

youtube-dl --list-thumbnails "$1" |
    awk 'int($2) >= 400{ printf "%9s %s\n", $2"x"$3, $4 }'
