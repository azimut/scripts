#!/bin/bash
set -exuo pipefail

CODE="${1}"
BACK="${2}"
OUTPUT=out.png

rm -vf "${OUTPUT}"

freeze \
    --line-height 1.4 \
    --font.size 11 \
    --border.color "#515151" --border.radius 8 --border.width 4 \
    --font.family LiberationMono \
    -t github-dark \
    -o code.png \
    "${CODE}"

# https://usage.imagemagick.org/compose/
convert \
    \( code.png -resize 50%x -alpha set -background none -channel A -evaluate multiply 0.8 +channel \) \
    \( +clone -background black -shadow 80x20+20+0 \) \
    +swap \
    -background none \
    -layers merge \
    +repage \
    "${BACK}" \
    +swap \
    -geometry +20+0 \
    -gravity Center \
    -compose Over \
    -composite \
    "${OUTPUT}"

exec sxiv "${OUTPUT}"
