#!/bin/bash

mkdir -p tmp
cd tmp

rm -f *.png *.gif

END=$((30)) # seconds

for index in $(seq -w 1 $END); do
    import -window root -resize 320x240 screen-$index.png
    echo $index
    sleep 1 # one image per second
done

#delay=60 # realtime
delay=30 # twice-realtime

[[ -f screen-01.png ]] && {
    convert \
       -layers OptimizeTransparency \
       -ordered-dither o8x8,20 \
       +map \
       -loop 0 \
       -delay ${delay} \
       screen-*.png screen.gif
}

[[ -f screen.gif ]] && {
    gifsicle -O3 < screen.gif > screen.opt3.gif
}
