#!/bin/bash
set -eo pipefail
export LC_LOCALE=C

while :; do
    bkt --ttl=24hour -- curl 'http://all.api.radio-browser.info/json/stations/bycountrycodeexact/ar' |
        jq -r 'def trim: gsub("^[ ]+|[ ]+$";"");
               unique_by(.url_resolved) |
               unique_by(.name|ascii_downcase|trim)[] |
               [(.name|trim),.url_resolved] |
               @csv' |
        sort |
        fzf --with-nth=1 --delimiter=, |
        cut -f2 -d, |
        xargs --no-run-if-empty mpv
done
