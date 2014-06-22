#!/bin/bash
# Reference: https://github.com/taeram/zen-wallpaper

#FONT_PATH='/usr/share/fonts/TTF/sazanami-mincho.ttf'
FONT_PATH='/usr/share/fonts/TTF/sazanami-gothic.ttf'

usage(){
    cat <<EOF
Usage: $0 [-hkj] [-b]
-h use the hiragana character set
-k use the katakana character set
-j use the kanji values
-b use the provided image as background instead of the default
EOF
}

echoerr() { echo "$@" 1>&2; }
check_in_path(){
    local cmd=$1
    hash "$cmd" &>/dev/null || {
        echoerr "uError: command \"$cmd\" not found in \$PATH, please add it or install it..."
        exit 1
    }
}

check_in_path 'feh'
check_in_path 'convert'

[[ $# -eq 0 ]] && { echoerr 'Error: argument missing.'; usage; exit 1; }

# Reference: http://symbolcodes.tlt.psu.edu/bylanguage/japanesecharthiragana.html
declare -A hiragana
hiragana=(
    [あ]='a'  [い]='i'  [う]='u'  [え]='e'  [お]='o'
    [か]='ka' [き]='ki' [く]='ku' [け]='ke' [こ]='ko'
    [が]='ga' [ぎ]='gi' [ぐ]='gu' [げ]='ge' [ご]='go'
    [さ]='sa' [し]='si' [す]='su' [せ]='se' [そ]='so'
    [ざ]='za' [じ]='zi' [ず]='zu' [ぜ]='ze' [ぞ]='zo'
    [た]='ta' [ち]='ti' [つ]='tu' [て]='te' [と]='to'
    [だ]='da' [ぢ]='di' [づ]='du' [で]='de' [ど]='do'
    [な]='na' [に]='ni' [ぬ]='nu' [ね]='ne' [の]='no'
    [は]='ha' [ひ]='hi' [ふ]='hu' [へ]='he' [ほ]='ho'
    [ば]='ba' [び]='bi' [ぶ]='bu' [べ]='be' [ぼ]='bo'
    [ぱ]='pa' [ぴ]='pi' [ぷ]='pu' [ぺ]='pe' [ぽ]='po'
    [ま]='ma' [み]='mi' [む]='mu' [め]='me' [も]='mo'
    [や]='ya'           [ゆ]='yu'           [よ]='yo'
    [ら]='ra' [り]='ri' [る]='ru' [れ]='re' [ろ]='ro'
    [わ]='wa' [ゐ]='wi'           [ゑ]='we' [を]='wo'
    [ん]='n' 
    [ゔ]='vu'
)

# Reference: http://symbolcodes.tlt.psu.edu/bylanguage/japanesechartkatakana.html
declare -A katakana
katakana=(
    [ア]='a'  [イ]='i'  [ウ]='u'  [エ]='e'  [オ]='o'
    [カ]='ka' [キ]='ki' [ク]='ku' [ケ]='ke' [コ]='ko'
    [ガ]='ga' [ギ]='gi' [グ]='gu' [ゲ]='ge' [ゴ]='go'
    [サ]='sa' [シ]='si' [ス]='su' [セ]='se' [ソ]='so'
    [ザ]='za' [ジ]='zi' [ズ]='zu' [ゼ]='ze' [ゾ]='zo'
    [タ]='ta' [チ]='ti' [ツ]='tu' [テ]='te' [ト]='to'
    [ダ]='da' [ヂ]='di' [ヅ]='du' [デ]='de' [ド]='do'
    [ナ]='na' [ニ]='ni' [ヌ]='nu' [ネ]='ne' [ノ]='no'
    [ハ]='ha' [ヒ]='hi' [フ]='hu' [ヘ]='he' [ホ]='ho'
    [バ]='ba' [ビ]='bi' [ブ]='bu' [ベ]='be' [ボ]='bo'
    [パ]='pa' [ピ]='pi' [プ]='pu' [ペ]='pe' [ポ]='po'
    [マ]='ma' [ミ]='mi' [ム]='mu' [メ]='me' [モ]='mo'
    [ヤ]='ya'           [ユ]='yu'           [ヨ]='yo'
    [ラ]='ra' [リ]='ri' [ル]='ru' [レ]='re' [ロ]='ro'
    [ワ]='wa' [ヰ]='wi'           [ヱ]='we' [ヲ]='wo'
    [ン]='n	' 
    [ヴ]='vu' [ヷ]='va' [ヸ]='vi' [ヹ]='ve' [ヺ]='vo'
)

# Reference: http://japanese.about.com/od/kan2/a/100kanji.htm
declare -A kanji
kanji=(
    [日]='sun'
    [一]='one'
    [大]='big'
    [年]='year'
    [中]='middle'
    [会]='to meet'
    [人]='human being, people'
    [本]='book'
    [月]='moon, month'
    [長]='long'
    [国]='country'
    [出]='to go out'
    [上]='up, top'
    [十]='ten'
    [生]='life'
    [子]='child'
    [分]='minute'
    [東]='east'
    [三]='three'
    [行]='to go'
    [同]='same'
    [今]='now'
    [高]='high, expensive'
    [金]='money, gold'
    [時]='time'
    [手]='hand'
    [見]='to see, to look'
    [市]='city'
    [力]='power'
    [米]='rice'
    [自]='oneself'
    [前]='before'
    [円]='Yen (Japanese currency)'
    [合]='to combine'
    [立]='to stand'
    [内]='inside'
    [二]='two'
    [事]='affair, matter'
    [社]='company, society'
    [者]='person'
    [地]='ground, place'
    [京]='capital'
    [間]='interval, between'
    [田]='rice field'
    [体]='body'
    [学]='to study'
    [下]='down, under'
    [目]='eye'
    [五]='five'
    [後]='after'
    [新]='new'
    [明]='bright, clear'
    [方]='direction'
    [部]='section'
    [女]='woman'
    [八]='eight'
    [心]='heart'
    [四]='four'
    [民]='people, nation'
    [対]='opposite'
    [主]='main, master'
    [正]='right, correct'
    [代]='to substitute, generation'
    [言]='to say'
    [九]='nine'
    [小]='small'
    [思]='to think'
    [七]='seven'
    [山]='mountain'
    [実]='real'
    [入]='to enter'
    [回]='to turn around, time'
    [場]='place'
    [野]='field'
    [開]='to open'
    [万]='ten thousand'
    [全]='whole'
    [定]='to fix'
    [家]='house'
    [北]='north'
    [六]='six'
    [問]='question'
    [話]='to speak'
    [文]='letter, writings'
    [動]='to move'
    [度]='degree, time'
    [県]='prefecture'
    [水]='water'
    [安]='inexpensive, peaceful'
    [氏]='courtesy name (Mr., Mister)'
    [和]='harmonious, peace'
    [政]='government, politics'
    [保]='to maintain, to keep'
    [表]='to express, surface'
    [道]='way'
    [相]='phase, mutual'
    [意]='mind, meaning'
    [発]='to start, to emit'
    [不]='not, un~, in~'
    [党]='political party'
)

while getopts ':hkjb:f' opt; do
    case $opt in
        h)
            rand_char=$(echo ${!hiragana[@]} | tr ' ' '\n' | shuf -n1)
            rand_desc=${hiragana[$rand_char]}
            ;;
        k)
            rand_char=$(echo ${!katakana[@]} | tr ' ' '\n' | shuf -n1)
            rand_desc=${katakana[$rand_char]}
            ;;
        j)
            rand_char=$(echo ${!kanji[@]} | tr ' ' '\n' | shuf -n1)
            rand_desc=${kanji[$rand_char]}
            ;;
        b)  
            [[ -f $OPTARG ]] && IMAGE_SOURCE=$OPTARG
            ;;
        \?)
            echoerr 'Error: Not implemented!'
            usage
            exit 1
            ;;
        :)
            echoerr 'Error: -'"${OPTARG}"' needs an argument.'
            usage
            exit 1
            ;;
    esac
done

[[ -z $rand_char || -z $rand_desc ]] && {
    usage
    exit 1
}

BACKGROUND=${IMAGE_SOURCE:-'-size 1600x900 xc:black'}

convert ${BACKGROUND} \
    -font $FONT_PATH \
    -pointsize 200 \
    -draw 'gravity center fill white text 0,0 "'$rand_char'"' \
    -pointsize 50 \
    -draw 'gravity center fill white text 0,150 "'"${rand_desc}"'"' \
    wp.png

feh --bg-fill wp.png
