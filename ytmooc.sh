#!/bin/bash

set -eu

err() { echo "ERROR: $*" >&2; }
usage() {
	cat <<EOF
yt-dlp flag wrapper to download playlists of videos

Usage:
   $(basename $0) [-RSIA] [-r RATE] [-s START] [-v MAXHEIGHT] URL

 -R       Reverse playlist order.
 -S       Download subtitles.
 -I       Add playlist number in filename.
 -A       Download a lower quality audio.
 -r       Set maximum download rate.
 -s 2     Set starting index number in playlist.
 -v 720   Set max height of the video to download.
EOF
}

OPTS=(--format='bestvideo+bestaudio')
while getopts ":hRSIAv:s:r:" arg; do
	case $arg in
	h) echo "help" ;;
	R) OPTS+=(--playlist-reverse) ;;
	S) OPTS+=(--write-subs --sub-langs 'en.*,es.*') ;;
	I) OPTS+=(--output='%(playlist_index)03d-%(title)s[%(id)s].%(ext)s') ;;
	A) OPTS=(${OPTS[@]/bestaudio/bestaudio[asr<40k]}) ;;
	v) OPTS=(${OPTS[@]/bestvideo/bestvideo[height<$OPTARG]}) ;;
	r) OPTS+=(--limit-rate="${OPTARG}") ;;
	s) OPTS+=(--playlist-start="${OPTARG}") ;;
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
