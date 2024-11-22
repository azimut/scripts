#!/bin/bash

set -euo pipefail

find . -type f -printf '%s %p\n' |
    sort -rn |
    head -n "${1:-10}" |
    while read -r size file; do
        printf '%5s\t%s\n' "$(numfmt --to=iec "${size}")" "${file}"
    done
