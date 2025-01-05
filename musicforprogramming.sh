#!/bin/bash
#
# Description: returns a list of .mp3 links found in musicforprogramming.net
#

set -eo pipefail

curl -s 'https://musicforprogramming.net/latest/' |
    pup '#sapper div a text{}' |
    sed --sandbox \
        '/^[0-9]/!d
         s/^0//
         s/: /-/
         s/\./_/g
         s/ /_/g
         s/+/and/
         s/[_]\+/_/g
         s/^/music_for_programming_/
         s/$/.mp3/
         s#^#https://datashat.net/#' |
    tr '[:upper:]' '[:lower:]'
