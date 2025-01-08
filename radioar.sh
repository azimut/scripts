#!/bin/bash

set -eo pipefail

export LC_LOCALE=C

# curl http://all.api.radio-browser.info/json/stations/bycountrycodeexact/ar
cat "${HOME}/projects/elm/radios/radios.ar.json" |
    jq -r 'unique_by(.url_resolved)[] | [.name,.url_resolved] | @csv' |
    sort -k1,1 -t, |
    fzf --with-nth=1 --delimiter=, |
    cut -f2 -d, |
    xargs --no-run-if-empty mpv
