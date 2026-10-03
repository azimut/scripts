#!/bin/bash
set -eux

SOX="${SOX:-/usr/bin/sox}"

while true; do
    effect="$(
        "${SOX}" --help-effect all |
            sed '1,4d' |
            awk -v RS='\n\n\n' '{ idx=index($0,"\n"); print(idx ? substr($0,0,idx-1) : $0) }' |
            fzf --tiebreak=begin |
            cut -f1 -d' '
    )"
    "${SOX}" --help-effect "${effect}" 2>/dev/null | sed '1,3d' | less
done
