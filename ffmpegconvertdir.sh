#!/bin/bash
#
# Description:
#   used to reduce the size of a bunch of videos
#   while keeping their directory structure
#

set -euo pipefail

info() {
	notify-send -t "$((5 * 1000))" -- \
		"$0" \
		"<span color='#57dafd' font='20px'>${1}</span>"
}

[[ $# -eq 0 ]] && {
	echo "ERROR: missing argument"
	echo "Usage:"
	echo "    $0 <SRCDIR> [VIDEO_FILTER]"
	exit 1
}

[[ ! -d ${1} ]] && {
	echo "ERROR: src does not exists"
	exit 1
}

SRC="$(realpath "${1}")"
FILTERS="${2:-scale=960:-1}"

before="$(du -sh "${SRC}" | cut -f1)"

# Create DST directories
find "${SRC}" -mindepth 1 -type d |
	while read -r dir; do
		mkdir -vp ".${dir#"${SRC}"}"
	done

# Copy non-video files
find "${SRC}" -type f -not \( -iname \*.mp4 -o -iname \*.mkv \) |
	while read -r srcfile; do
		dstfile=".${srcfile#"${SRC}"}"
		[[ -f ${dstfile} ]] && {
			continue
		}
		cp "${srcfile}" "${dstfile}"
	done

# Counters
total="$(find "${SRC}" -type f \( -iname \*.mp4 -o -iname \*.mkv \) | wc -l)"
i=0

# Convert videos
find "${SRC}" -type f \( -iname \*.mp4 -o -iname \*.mkv \) | sort |
	while read -r srcfile; do
		dstfile=".${srcfile#"${SRC}"}"
		((++i))
		info "${i} of ${total}"
		[[ -f ${dstfile} ]] && {
			continue
		}
		ffbar -i "${srcfile}" -ac 1 -vf "${FILTERS}" "${dstfile}"
	done

echo "Before: ${before}"
echo "After:  $(du -sh . | cut -f1)"

info "done!"
