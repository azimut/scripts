#!/bin/bash
set -eo pipefail
export LC_LOCALE=C

while :; do
    bkt --ttl=24hour -- curl -s 'http://all.api.radio-browser.info/json/stations/bycountrycodeexact/ar' |
        jq -r 'def trim: gsub("^[ ]+|[ ]+$";"");
               map(select(.lastcheckok > 0)) |
               unique_by(.url_resolved) |
               unique_by(.name|ascii_downcase|trim)[] |
               [(.name|trim),.url_resolved] |
               @tsv' |
        sort |
        fzf --with-nth=1 --delimiter=$'\t' |
        cut -f2- -d$'\t' |
        xargs --no-run-if-empty mpv
done
