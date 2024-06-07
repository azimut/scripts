#!/bin/sh

# Description: sums up the reproduction time of all media under CWD

find . -regextype egrep -iregex '.*(mp4|mp3|webm)' -print0 |
	xargs -n1 -0 -r -P2 \
		ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 |
	awk '{ t+=$1; printf("\033[10D%s", strftime("%H:%M:%S", t, 1)); } END { if(t) print("") }'
