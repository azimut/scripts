#!/bin/bash

set -eu

err() { echo "ERROR: $*" >&2; }
usage() {
	echo "Plays the audio of the given playlist in a random order."
	echo "Usage:"
	printf "\t%s [URLS...]\n" "$(basename $0)"
}

(($# != 1)) && err "no url provided" && usage && exit 22
[[ $1 != *playlist* ]] && err "invalid url provided" && usage && exit 22

remember() {
	local queue="${HOME}/Music/music.txt"
	grep -xFq "$1" "${queue}" || echo "$1" >>"${queue}"
}
play() {
	mpv --ytdl-format=bestaudio \
		--ytdl-raw-options='playlist-random=' \
		"$1"
}

play "$1"
remember "$1" # here we should know for sure it's a good link
