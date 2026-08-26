#!/bin/bash
set -exuo pipefail
FILE="$1"
THRESHOLD="${2:-0.3}"
ffmpeg -nostdin -loglevel quiet \
    -i "${FILE}" \
    -vf "select='gt(scene,${THRESHOLD})',
         drawtext=x='(w/2)-(tw/2)':
                  y='(h/2)-(th/2)':
                  fontsize=h/6:
                  fontcolor=white:
                  bordercolor=black:
                  borderw=2:
                  text='%{pts\:hms}',
         scale=160:-1,
         tile=6x80" \
    -frames:v 1 -qscale:v 3 -f image2 - |
    convert jpg:- -define trim:edges=south -fuzz 10% -trim gif:- |
    feh -
