#!/bin/bash
#
# Description: returns a list of .mp3 links for musicforprogramming.net
#
curl -s 'https://musicforprogramming.net/latest/' |
	pup '#sapper div a text{}' |
	sed '/^[0-9]/!d
         s/^0//
         s/: /-/
         s/\./_/g
         s/ /_/g
         s/+/and/
         s/[_]\+/_/g
         s/^/music_for_programming_/
         s/$/.mp3/' |
	tr '[:upper:]' '[:lower:]' |
	sed 's#^#https://datashat.net/#'
