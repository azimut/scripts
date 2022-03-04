#!/bin/bash
set -exuo pipefail

INPUT="$1"
test -f "${INPUT}"
output="$(basename "${INPUT}").mp3"

div() { echo "$(</dev/stdin) / ${1}" | bc -l ; }
round(){ printf "%.0f" "$(</dev/stdin)"; }
video_to_seconds() {
    ffprobe -loglevel error -hide_banner -of csv=p=0 -show_entries format=duration "${1}"
}
seconds_to_timestamp(){
    date -u --date=@"$(</dev/stdin)" +%H:%M:%S
}

rm -f output.jpg
ffmpeg -ss "$(video_to_seconds "${INPUT}" | div 2 | round | seconds_to_timestamp)" \
       -hide_banner -y -i "${INPUT}" -frames:v 1 output.jpg
test -s output.jpg
ffmpeg -hide_banner -i "${INPUT}" -i output.jpg -ac 1 -c:v mjpeg -map 0:a -map 1:v "${output}"
rm -f output.jpg
