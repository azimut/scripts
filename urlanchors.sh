#!/bin/sh
set -e
lynx -dump -width=1024 -list_inline "$1" |
    sed 's/^\s*//'
