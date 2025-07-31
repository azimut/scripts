#!/bin/sh
set -xe
AUTHOR='Pinback'
TITLE='Forced Motion'
FONT='Purisa'
COVER="$HOME/pinback-too-many-shadows-Cover-Art.jpg"
AUDIO='/home/sendai/Forced Motion - Pinback [De3DpI7YNUs].webm'

# "I need the combination to unlock your code"

magick \
    -size 660x880 xc:transparent \
    -draw "fill black roundrectangle 0,0 %[fx:w],%[fx:h] 40,40" \
    -channel alpha -fx 'if(a, 0.85, 0)' +channel \
    -font "${FONT}" \
    -draw "fill white font-size 60 text %[fx:w*.08],%[fx:h*.83] '${TITLE}'" \
    -draw "fill gray font-size 50 text %[fx:w*.08],%[fx:h*.89] '${AUTHOR}'" \
    \( "${COVER}" -gravity center -crop '%[fx:w]x%[fx:w]+0+0' -resize 550x \) \
    -gravity north -geometry '+0+%[fx:v.h*.1]' -composite \
    "${0##*/}.png"

# -vf 'crop=(in_h*(9/16)):in_h' ~/out.mp4

ffmpeg -y \
    -i "${0##*/}.png" \
    -f lavfi -i 'color=color=red:size=720x1280' \
    -i "${AUDIO}" \
    -filter_complex '
      [1][0]
        overlay=
            x=(main_w-overlay_w)/2:
            y=w/5:
            shortest=true' \
    "${0##*/}.mp4"
