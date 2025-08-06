#!/bin/bash
set -exuo pipefail

CODE="${1}"
BACK="${2}"

rm -f code.png code-trans.png

freeze \
    --line-height 1.4 \
    --font.size 11 \
    --border.color "#515151" --border.radius 8 --border.width 4 \
    --font.family LiberationMono \
    -t github-dark \
    -o code.png \
    "${CODE}"

convert code.png -alpha set -background none -channel A -evaluate multiply 0.7 +channel \
    code-trans.png

ffmpeg -y -nostats -hide_banner -nostdin \
    -i "${BACK}" \
    -i code-trans.png \
    -filter_complex "
      [0:v] null                [back];
      [1:v] scale=in_w/2:in_h/2 [cover];
      [back][cover]
        overlay=
            x=((W/2)-(w/2)):
            y=((H/2)-(h/2)):
            shortest=false" \
    -metadata "title=$(basename "${CODE}")" \
    "${CODE##*/}.mp4"

exec mpv "${CODE##*/}.mp4"
