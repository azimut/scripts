#!/bin/bash
set -o nounset
set -o errexit
set -o pipefail

[[ $# -lt 1 ]] && exit 1

for track in *.mp3; do
    title="$(echo "$track" | cut -f1 -d'-')"
    title="$(echo "$track" | rev | cut -b17- | rev)"
    [[ $title == *mp3 ]] && continue
    set -x
    id3ted --delete-all "$track"
    id3ted -a "$1" "$track"
    set +o nounset
    [[ ! -z $2 ]] && id3ted -A "$2" "$track"
    set -o nounset
    id3ted -t "$title" "$track"
    { set +x; } &> /dev/null
done
