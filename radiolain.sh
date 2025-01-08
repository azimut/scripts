#!/bin/bash

set -eo pipefail

readonly BASEURL='https://lainchan.org/music/'
readonly PAGES=('' '2.html') # '3.html' '4.html' '5.html'

lynx -dump -listonly -nonumbers "${PAGES[@]/#/${BASEURL}}" |
    awk -W interactive \
        '/(mp3|ogg)$/ && !seen[$0]++'
