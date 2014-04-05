#!/bin/bash

# Description: scramble the given string

# $ ./randstring.sh abcdefghijklmnopqrstuvwxyz
#  String original:    abcdefghijklmnopqrstuvwxyz
#  String desordenada: bljcqyrmanpfizsdhugxwtkove

[[ -z $1 ]] && {
    echo 'Missing argument'
    exit 1
}

echo    'String original:    '"$1"
echo -n 'String desordenada: '
echo -n "${1}" | fold -w1 | sort -R | xargs -ILETTER echo -n LETTER
echo
