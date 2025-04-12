#!/bin/bash
set -eo pipefail

export LC_ALL=C # byte sort comparison
usage() {
    echo "Lists unique <a>nchor links on the given url."
    echo -e "Usage:\n\t$(basename "$0") URL"
}
(($# != 1)) && usage && exit 1

bkt --ttl=1hour -- \
    lynx -dump -listonly -nonumbers -image_links -hiddenlinks=merge "$1" |
    sort -u
