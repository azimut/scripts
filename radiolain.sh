#!/bin/bash
set -eo pipefail
BASEURL='https://lainchan.org/music/'
PAGES=('' '2.html' '3.html' '4.html' '5.html')

bkt --ttl=24hour -- lynx -dump -listonly -nonumbers "${PAGES[@]/#/${BASEURL}}" |
    awk -W interactive \
        '(/(mp3|ogg)$/||/youtube.com\/watch/||/youtu\.be/) && !seen[$0]++'
