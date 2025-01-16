#!/bin/bash
set -eo pipefail

youtube-dl --list-thumbnails "$1" |
    awk 'int($2) >= 400{ printf "%9s %s\n", $2"x"$3, $4 }'
