#!/bin/bash

set -eu

err() { echo "ERROR: $*" >&2; }
usage() {
	echo -e "yt-dlp flag wrapper to download playlists of videos"
	echo "Usage:"
	echo -e "\t$(basename $0) [-S] [-I] [-r RATE] [-s START] [-m MAXHEIGHT] URL"
}

OPTS=()
while getopts ":hSIm:s:r:" arg; do
	case $arg in
	h) echo "help" ;;
	S) OPTS+=(--write-subs --sub-langs 'en.*,es.*') ;;
	I) OPTS+=(--output='%(playlist_index)03d-%(title)s[%(id)s].%(ext)s') ;;
	r) OPTS+=(--limit-rate="${OPTARG}") ;;
	s) OPTS+=(--playlist-start="${OPTARG}") ;;
	m) OPTS+=(--format='bestvideo[height<'"${OPTARG}"']+bestaudio') ;;
	:)
		err "Mandatory argument missing for given flag $OPTARG"
		usage
		exit 1
		;;
	\?)
		err "Unknown flag"
		usage
		exit 1
		;;
	esac
done
shift $((OPTIND - 1)) # allow positional arguments

(($# != 1)) && err "Missing URL parameter." && usage && exit 1

set -x
URL="${1}"
echo -n "${URL}" >url
yt-dlp "${OPTS[@]}" --continue "${URL}"
