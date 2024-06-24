#!/bin/bash

set -euo pipefail

mkdir -p tmp
cd tmp
rm -f ./*.gif ./*.mp4 ./*.png

fps=${1:-10}
seconds=${2:-10}
output=${3:-mp4} # gif/mp4
scaledown=${4:-5}

frames=$((fps * seconds))
frames="${frames%.*}"
sleep="$(echo "scale=8; 1/${fps}" | bc)"
IFS="x" read -r -a RESOLUTION < <(xdpyinfo | sed -nE '/dimensions/s#[^0-9]+([0-9x]+).*#\1#p')
dimension="$((RESOLUTION[0] / scaledown))x$((RESOLUTION[1] / scaledown))"

for frame in $(seq -w 1 ${frames}); do
	echo "${frame}/${frames}"
	start="${EPOCHREALTIME/,/.}"
	import -window root -resize "${dimension}" "screen-${frame}.png"
	end="${EPOCHREALTIME/,/.}"
	sleep "$(bc -q <<<"scale=10;
                       if ((${end} - ${start}) > ${sleep})
                          { 0; } else { (${sleep} - (${end} - ${start})); } ")"
done

case "${output}" in
gif)
	delay="$(bc <<<"${sleep} * 100")"
	delay="${delay%.*}"
	convert \
		-layers OptimizeTransparency \
		-ordered-dither o8x8,20 \
		+map \
		-loop 0 \
		-delay "${delay}" \
		screen-*.png \
		screen.gif
	gifsicle -O3 <screen.gif >screen.opt3.gif
	mpv --loop=inf screen.opt3.gif
	;;
mp4)
	ffmpeg -y -f image2 -framerate "${fps}" -i screen-%02d.png -vcodec libx264 -crf 22 screen.mp4
	mpv --loop=inf screen.mp4
	;;
*)
	echo "Error: invalid output format requested: ${output}"
	exit 1
	;;
esac
