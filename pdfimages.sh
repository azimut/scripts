#!/bin/bash
set -eu

function cleanup {
    if [ -n "${tmpdir:-}" ]; then
        rm -f "${tmpdir}"/*
        rmdir "${tmpdir}"
    fi
}

trap cleanup EXIT

function usage {
    echo "Wrapper around pdfimages, to quickly see images on a pdf."
    echo -e "Usage:\n\t$(basename "$0") PDFFILE"
}

(($# != 1)) && usage && exit 1
[ ! -f "$1" ] && usage && exit 1

tmpdir="$(mktemp --directory)"
pdf="$(readlink -f "$1")"

cd "${tmpdir}"
pdfimages -p -all "${pdf}" tmp
sxiv "${tmpdir}"
