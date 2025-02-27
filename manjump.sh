#!/bin/bash
set -eu

usage() {
    echo "Opens given man page if only one section exists."
    echo "Otherwise opens selection if more than one section exits."
    echo -e "\nUSAGE\n\t$(basename "$0") [SECTION] PAGE"
}

(($# == 2)) && man "$1" "$2" && exit 0
(($# != 1)) && usage && exit 1

readarray lines < <(man -f "$1" 2>/dev/null || true)
case "${#lines[@]}" in
0) echo "ERROR: No man page found :/" >&2 && exit 1 ;;
1) man "$1" ;;
*)
    section="$(printf '%s' "${lines[@]}" | fzf | awk '{ print substr($2,2,1) }')"
    man "${section}" "$1"
    ;;
esac
