#!/bin/bash
set -exuo pipefail

CODE="${1}"
BACK="${2}"

freeze \
    --line-height 1.4 \
    --show-line-numbers \
    --font.size 10 \
    --background "#ff0000" \
    --border.color "#515151" --border.radius 8 --border.width 2 \
    --font.family LiberationMono \
    -t github-dark \
    -o out.png \
    "${CODE}"

code_dimensions=($(identify -format "%w %h" out.png))
back_dimensions=($(identify -format "%w %h" "${BACK}"))

echo "${code_dimensions[0]}"
echo "${back_dimensions[0]}"

new_width="$(echo 0k "${code_dimensions[0]}" 1.4 / p | dc)"
convert "${BACK}" \
    \( out.png -resize "${new_width}"x "${BACK}" \) \
    -gravity Center -composite out3.png
