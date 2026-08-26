#!/bin/bash
set -xue

FONT='Spotify-Mix' # see ~/.local/share/fonts/*.ttf

yad --form --escape-ok --title="magick thumbnail" \
    --image-filter --add-preview \
    --field="Author" \
    --field="Title" \
    --field="Thumbnail:":FL \
    --field="Background":CHK \
    --field="Cleanup":CHK \
    --field="Title:":CLR \
    --field="Author:":CLR \
    '' '' '' FALSE TRUE '#ffffff' '#808080' |
    while IFS='|' read -r AUTHOR TITLE COVER BACKGROUND CLEANUP TCOLOR ACOLOR; do
        # Square it + Bevel
        magick \
            "${COVER}" \
            -gravity center \
            -crop '%[fx:((w>h)?h:w)]x%[fx:((w>h)?h:w)]+0+0' \
            -resize 550x \
            -alpha set \
            \( \
            +clone \
            -size '%[fx:((w>h)?h:w)]x%[fx:((w>h)?h:w)]' \
            xc:none \
            +swap +delete \
            -draw 'roundrectangle 0,0,%[fx:((w>h)?w:h)],%[fx:((w>h)?w:h)],15,15' \
            \) \
            -compose DstIn -composite \
            +repage \
            "${0##*/}.cover.png"

        if [[ $BACKGROUND == "TRUE" ]]; then
            magick \
                -size 660x880 xc:none \
                -draw "fill rgba(0,0,0,0.65) roundrectangle 0,0 %[fx:w],%[fx:h] 40,40" \
                -font "${FONT}-Bold" -draw "fill ${TCOLOR} font-size 60 text %[fx:w*0.08],%[fx:h*0.83] '${TITLE}'" \
                -font "${FONT}-Regular" -draw "fill ${ACOLOR} font-size 50 text %[fx:w*0.08],%[fx:h*0.89] '${AUTHOR}'" \
                "${0##*/}.cover.png" \
                -gravity north -geometry '+0+%[fx:v.h*0.1]' -composite \
                "${0##*/}.png"
        else
            magick \
                "${0##*/}.cover.png" \
                -gravity South -background transparent -splice 0x100 \
                -font "${FONT}-Bold" -pointsize 40 -fill "${TCOLOR}" -annotate +0+30 "${TITLE}" \
                -font "${FONT}-Regular" -pointsize 30 -fill "${ACOLOR}" -annotate +0+0 "${AUTHOR}" \
                "${0##*/}.png"
        fi

        [[ $CLEANUP == "TRUE" ]] && rm -vf "${0##*/}.cover.png"
        sxiv "${0##*/}.png"

    done
