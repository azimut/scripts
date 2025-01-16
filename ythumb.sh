#!/bin/bash
set -eo pipefail

function usage() {
    echo -e 'Returns the thumbnails urls of the given youtube video.\n'
    echo -e "\t$(basename "$0") [URL]"
}

(($# != 1)) && usage && exit 1

youtube-dl --list-thumbnails "$1" |
    awk 'int($2) >= 400{ printf "%9s %s\n", $2"x"$3, $4 }'
