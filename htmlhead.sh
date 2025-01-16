#!/bin/bash
set -eo pipefail

function usage() {
    echo -e "Returns the formatted <head> block of a page.\n"
    echo -e "Usage:\n\t$(basename "$0") [URL]"
}
(($# != 1)) && usage && exit 1

curl "$1" | pup 'head' | batcat -l html
