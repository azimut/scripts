#!/bin/fish

set OUTPUT out.png
trap "rm -vf $OUTPUT code.png" EXIT

set -- script (basename (status -f))
function usage
    echo "$script - Overlays an image of source code over the given image."
    echo "Usage:  $script [arguments] CODE IMAGE" >&2
    echo
    echo "  -a/--alpha - Code alpha transparency. Default: 0.6"
    echo "  -s/--scale - Code scale.              Default: 20"
    echo "  -f/--font  - Code font name.          Default: LiberationMono"
    echo "  -t/--theme - Code color theme.        Default: github-dark"
    echo
end

argparse -N2 -X2 's/scale=!_validate_int' 'a/alpha=' 'f/font=' 't/theme=' -- $argv || usage && exit 1
set -q _flag_scale || set _flag_scale 20
set -q _flag_alpha || set _flag_alpha 0.6
set -q _flag_font  || set _flag_font LiberationMono
set -q _flag_theme || set _flag_theme github-dark

set CODE $argv[1]
set BACK $argv[2]

freeze \
    --line-height 1.4 \
    --font.size 11 \
    --border.color "#515151" --border.radius 8 --border.width 4 \
    --font.family $_flag_font \
    -t $_flag_theme \
    -o code.png \
    $CODE

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
