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

convert \
    \( code.png -resize 70%x \) \
    \( +clone -background black -shadow 80x20+20+0 \) \
    +swap \
    -background none \
    -layers merge \
    +repage \
    "${BACK}" \
    +swap \
    -gravity Center \
    -compose Multiply \
    -composite \
    "${OUTPUT}"
