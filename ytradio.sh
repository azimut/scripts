#!/bin/bash

set -eu

err() { echo "ERROR: $*" >&2; }
usage() {
	echo "Plays the audio of the given playlist in a random order."
	echo "Usage:"
	printf "\t%s [URLS...]\n" "$(basename $0)"
}

(($# != 1)) && err "no url provided" && usage && exit 1
[[ $1 != *playlist* ]] && err "invalid url provided" && usage && exit

mpv --ytdl-format=bestaudio \
	--ytdl-raw-options='playlist-random=,lazy-playlist=' \
	"$1"
