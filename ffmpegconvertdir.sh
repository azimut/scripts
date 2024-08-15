#!/bin/bash

set -euo pipefail

DEFAULT_FILTERS='scale=960:-1'
DEFAULT_SKIP='00:00:00'
DEFAULT_RATE='30'
DEFAULT_ACHAN='1'

info() {
	notify-send -t "$((5 * 1000))" -- \
		"$(basename $0)" \
		"<span color='#57dafd' font='20px'>${1}</span>"
}

usage() {
	cat <<EOF
Reduces the size of videos, while keeping their directory structure.
Usage:
    $(basename $0) [-f VIDEO_FILTER] [-r FPS] [-s TIME] [-t TIME] [-a CHAN] SRCDIR

 -f FILTER  video filter to apply     default: ${DEFAULT_FILTERS}
 -r FPS     video frames per second   default: ${DEFAULT_RATE}
 -s TIME    beginning trim            default: ${DEFAULT_SKIP}
 -t TIME    ending trim               eg: 00:01:02
 -a CHAN    number of audio channels  default: ${DEFAULT_ACHAN}
EOF
}

getduration() { ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$1" | cut -f1 -d'.'; } # TODO: handle float
time2sec() { date -d "1970-01-01T$* UTC" '+%s'; }
sec2time() { date -d "@$*" -u '+%H:%M:%S'; }

while getopts ":hs:f:r:t:a:" arg; do
	case $arg in
	h) usage && exit 0 ;;
	f) FILTERS="$OPTARG" ;;
	s) SKIP="$OPTARG" ;;
	r) RATE="$OPTARG" ;;
	t) TRIM="$OPTARG" ;;
	a) ACHAN="$OPTARG" ;;
	*) usage && exit 22 ;; # EINVAL
	esac
done
shift $((OPTIND - 1))

[[ $# -ne 1 ]] && {
	echo "ERROR: missing argument"
	usage && exit 22 # EINVAL
}
[[ ! -d ${1} ]] && {
	echo "ERROR: src does not exists"
	usage && exit 2 # ENOENT
}

SRC="$(realpath "${1}")"
FILTERS="${FILTERS:-$DEFAULT_FILTERS}"
SKIP="${SKIP:-$DEFAULT_SKIP}"
RATE="${RATE:-$DEFAULT_RATE}"
ACHAN="${ACHAN:-$DEFAULT_ACHAN}"

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

# Counter
total="$(find "${SRC}" -type f \( -iname \*.mp4 -o -iname \*.mkv \) | wc -l)"
printf '\nNumber of file to convert: %d\n\n' "${total}"

# Convert videos
before="$(du -sh "${SRC}" | cut -f1)"
i=0
find "${SRC}" -type f \( -iname \*.mp4 -o -iname \*.mkv \) | sort |
	while read -r srcfile; do
		dstfile=".${srcfile#"${SRC}"}"
		info "$((total - i++)) remaining..."
		[[ -f ${dstfile} ]] && {
			continue
		}
		if [[ -z ${TRIM+x} ]]; then
			ffbar -ss "${SKIP}" -i "${srcfile}" -r "${RATE}" -ac "${ACHAN}" -ar 22050 -vf "${FILTERS}" "${dstfile}" || {
				rm -vf "${dstfile}"
				exit 1
			}
		else
			length="$(sec2time $(($(getduration "${srcfile}") - $(time2sec "${SKIP}") - $(time2sec "${TRIM}"))))"
			ffbar -ss "${SKIP}" -t "${length}" -i "${srcfile}" -r "${RATE}" -ac "${ACHAN}" -ar 22050 -vf "${FILTERS}" "${dstfile}" || {
				rm -vf "${dstfile}"
				exit 1
			}
		fi

	done

echo
echo "Before: ${before}"
echo "After:  $(du -sh . | cut -f1)"
echo
info "done!"
