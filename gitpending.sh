#!/bin/bash
set -e
BASEDIR="${HOME}/projects"

bkt --ttl 60m --discard-failures -- find "${BASEDIR}" -type d -name '.git' |
    while read -r gitdir; do
        [[ ${gitdir} == **thirdparty** || ${gitdir} == *texts* ]] && continue
        dir="${gitdir%/.git}"
        cd "${dir}"
        if ! git diff --quiet; then
            echo "=== ${dir} ==="
            git status --porcelain
        fi
        cd - &> /dev/null
    done
