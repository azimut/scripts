#!/bin/bash

update(){
    local track="$1"
    ttrack="$(echo "$track" | sed 's/—/-/g' | sed 's/[\. ]*-[\. ]*/-/g' | rev | cut -b5- | rev)"
    title="$(echo "$ttrack" |awk -F '-' '{print $2}' )"
    #title="$(echo "$ttrack"  |awk -F '-' '{print $2}' | cut -f1 -d'(' | rev | cut -b5- | rev)"
    artist="$(echo "$ttrack"  |awk -F '-' '{print $1}' | cut -f1 -d'(')"
    #title="$(echo "$ttrack"  |awk -F ';' '{print $2}' | cut -f1 -d'(' | cut -f1 -d'[')"
    [[ $title == *mp3 ]] && return  1
    set -x
    id3ted --delete-all "$track"
    id3ted -a "$artist" "$track"
    id3ted -t "$title"  "$track"
#    { set +x; } &> /dev/null
}

if [[ -n $1 ]]; then
    update "$1"
else
    for track in *.mp3; do
        update "$track"
    done
fi
