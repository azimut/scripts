#!/bin/bash
set -eu

SOX="${SOX:-/usr/bin/sox}"

while true; do
    effect="$(
        "${SOX}" --help-effect all |
            sed '1,4d' |
            awk -v RS='\n\n\n' '{ idx=index($0,"\n"); print(idx ? substr($0,0,idx-1) : $0) }' |
            column --table --table-columns-limit 2 |
            fzf --tiebreak=begin |
            cut -f1 -d' '
    )"
    [[ -z "${effect}" ]] && break
    "${SOX}" --help-effect "${effect}" 2>/dev/null | sed '1,3d' | less
done
