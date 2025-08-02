#!/bin/bash
set -euo pipefail
FILE="$(readlink -f "$1")"
i=0
mkdir -p clips/
rm -f clips/*
bkt --ttl=1h -- ffmpeg -nostdin -nostats -i "${FILE}" -vf "select='gt(scene,0.4)',showinfo=0" -f null - |&
    grep showinfo |
    grep ' n: ' |
    cut -b66-72 |
    xargs echo "0" |
    xargs printf '%s %s\n' |
    while read -r start end; do
        [[ -z "${start}" || -z "${end}" || "${start}" == "${end}" ]] && continue
        ((i++)) || true
        (
            set -x
            ffmpeg -y -nostdin -loglevel quiet \
                -ss "${start}" -to "${end}" -an -i "${FILE}" \
                -c:v copy "clips/${i}.${FILE##*.}"
        )
    done
