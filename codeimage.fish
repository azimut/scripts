#!/bin/fish

argparse --min-args=2 'h/help' 's/scale=' 'a/alpha=' -- $argv
or exit
set -q _flag_scale || set _flag_scale 20
set -q _flag_alpha || set _flag_alpha 0.6

set CODE $argv[1]
set BACK $argv[2]
set OUTPUT out.png

trap "rm -vf $OUTPUT code.png" EXIT

and freeze \
    --line-height 1.4 \
    --font.size 11 \
    --border.color "#515151" --border.radius 8 --border.width 4 \
    --font.family LiberationMono \
    -t github-dark \
    -o code.png \
    $CODE

# https://usage.imagemagick.org/compose/
and convert \
    \( code.png -resize $_flag_scale%x -alpha set -background none -channel A -evaluate multiply $_flag_alpha +channel \) \
    \( +clone -background black -shadow 80x20+20+0 \) \
    +swap \
    -background none \
    -layers merge \
    +repage \
    $BACK \
    +swap \
    -geometry +20+0 \
    -gravity Center \
    -compose Over \
    -composite \
    $OUTPUT

and sxiv $OUTPUT
