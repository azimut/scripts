#!/bin/bash

set -eo pipefail

# Returns a list .mp3 links
curl -s 'https://musicforprogramming.net/latest/' |
    pup '#sapper div a text{}' |
    sed --sandbox \
        '/^[0-9]/!d
         s/^0//
         s/: /-/
         y/\. /__/
         s/_\+/_/g
         s/+/and/g
         s#^#https://datashat.net/music_for_programming_#
         s/$/.mp3/' |
    tr '[:upper:]' '[:lower:]'
