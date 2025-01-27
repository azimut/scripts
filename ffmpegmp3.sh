#!/bin/bash
set -exuo pipefail

timestamp() { date -u --date=@"${1}" +%H:%M:%S; }
seconds() { ffprobe -of csv=p=0 -show_entries format=duration "${1}" 2>/dev/null; }
cleanup_thumbnails() { rm -f extract_tmp*jpg; }

trap 'cleanup_thumbnails' EXIT

N=5 # number of thumbnails
INPUT="$1"
test -f "${INPUT}"

# Extract Thumbnails
step="$(seconds "${INPUT}" | dc -e "?$N/p")"
for ((i = 0; i < N; i++)); do
    ffmpeg -hide_banner -loglevel error \
        -ss "$(timestamp $((step * i)))" \
        -i "${INPUT}" \
        -frames:v 1 \
        "extract_tmp${i}.jpg"
done

# Create .mp3
ffmpeg -y -hide_banner \
    -i "${INPUT}" \
    -i "$(ipickme -s 200 ./extract_tmp*jpg)" \
    -ac 1 -c:v mjpeg -map 0:a -map 1:v \
    "$(basename "${INPUT}").mp3"
