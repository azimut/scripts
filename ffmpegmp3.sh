#!/bin/bash
set -euo pipefail

seconds() { ffprobe -of csv=p=0 -show_entries format=duration "${1}" 2>/dev/null; }
usage() {
    echo -e "Converts a video to an .mp3 picks a thumbnail.\n"
    echo -e "Usage:\n\t$(basename "$0") VIDEO"
}

trap 'rm -f -- f00thumbnail*jpg' EXIT

(($# != 1)) && usage && exit 1
[[ ! -f "$1" ]] && usage && exit 1

N=5 # number of thumbnails
INPUT="$1"

echo "[+] Extracting $N thumbnails..."
offset="$(seconds "${INPUT}" | dc -e "?$N/p")"
for ((i = 0; i < N; i++)); do
    ffmpeg -hide_banner -loglevel error \
        -ss "$((offset * i))" \
        -i "${INPUT}" \
        -frames:v 1 \
        "f00thumbnail${i}.jpg"
done

echo '[+] Creating .mp3'
ffbar -y -hide_banner \
    -i "${INPUT}" \
    -i "$(ipickme -s 200 ./f00thumbnail*jpg)" \
    -ac 1 -c:v mjpeg -map 0:a -map 1:v \
    "$(basename "${INPUT}").mp3"
