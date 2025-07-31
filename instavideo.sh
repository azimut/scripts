#!/bin/sh
set -xe

AUTHOR='Pinback'
TITLE='Forced Motion'
FONT='Purisa'
COVER="$HOME/pinback-too-many-shadows-Cover-Art.jpg"
AUDIO='/home/sendai/Forced Motion - Pinback [De3DpI7YNUs].webm'
VIDEO='/home/sendai/Videos/The Computer Chronicles - Operating Systems (1984) [V5S8kFvXpo4].webm'
VIDEO='/home/sendai/Videos/Sisters.with.Transistors.2020.1080p.x265.AAC.MVGroup.org.mkv'

# "I need the combination to unlock your code"
#trap 'rm -f '"${0##*/}.png" EXIT
rm -vf "${0##*/}.mp4"

magick \
    -size 660x880 xc:transparent \
    -draw "fill black roundrectangle 0,0 %[fx:w],%[fx:h] 40,40" \
    -channel alpha -fx 'if(a, 0.85, 0)' +channel \
    -font "${FONT}" \
    -draw "fill white font-size 60 text %[fx:w*.08],%[fx:h*.83] '${TITLE}'" \
    -draw "fill gray font-size 50 text %[fx:w*.08],%[fx:h*.89] '${AUTHOR}'" \
    \( "${COVER}" -gravity center -crop '%[fx:w]x%[fx:w]+0+0' -resize 550x \) \
    -gravity north -geometry '+0+%[fx:v.h*.1]' -composite \
    -resize 40% \
    "${0##*/}.png"

# -f lavfi -i 'color=color=red:size=720x1280'
ffmpeg -y \
    -ss 00:21:06 -t 13 -i "${VIDEO}" \
    -ss 00:00:01 -t 22 -i "${AUDIO}" \
    -i "${0##*/}.png" \
    -filter_complex "
      [2:v] null                     [cover];
      [0:v]
        setpts=PTS*1.7,
        crop=(in_h*(9/16)):in_h,
        hue=s=0                      [back];
      [back][cover]
        overlay=
            x=(w/6):
            y=(w/6):
            shortest=false           [outv];
      [1:a] acopy                    [outa]
    " \
    -map '[outv]' -map '[outa]' "${0##*/}.mp4"
