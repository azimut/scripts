#!/bin/bash
set -eo pipefail

URL="http://all.api.radio-browser.info/json/stations/bycountrycodeexact/${1:-ar}"
while :; do
    bkt --ttl=24hour -- curl -s "${URL}" |
        jq -r 'def trim: gsub("^[ ]+|[ ]+$";"");
               map(select(.lastcheckok > 0)) |
               unique_by(.url_resolved) |
               unique_by(.name|ascii_downcase|trim)[] |
               [(.name|trim),.url_resolved] |
               @tsv' |
        sort |
        fzf --with-nth=1 --delimiter=$'\t' |
        cut -f2 |
        xargs --no-run-if-empty mpv
done
