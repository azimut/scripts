#!/bin/sh
export LC_ALL=C # byte sort comparison
bkt --ttl=1hour -- \
    lynx -dump -listonly -nonumbers -image_links -hiddenlinks=merge "$1" |
    sort -u
