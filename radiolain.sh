#!/bin/bash

set -eo pipefail

readonly BASEURL='https://lainchan.org/music/' # TODO: try 2.html - 5

lynx -dump -listonly -unique_urls -nonumbers "${BASEURL}" |
    grep -E '(mp3|ogg)$' |
    xargs mpv --no-video
