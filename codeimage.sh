#!/bin/bash
set -xuo pipefail

CODE="${1}"
BACK="${2}"

freeze \
    --line-height 1.4 \
    --font.size 11 \
    --border.color "#515151" --border.radius 8 --border.width 2 \
    --font.family LiberationMono \
    -t github-dark \
    -o code.png \
    "${CODE}"

convert "${BACK}" \
    \( code.png -resize 70%x "${BACK}" \) \
    -gravity Center -composite out3.png
