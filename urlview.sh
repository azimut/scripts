#!/bin/bash

set -exuo pipefail

LOGFILE="${HOME}/$(basename $0).log"
URL="${1}"
UA='Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20100101 Firefox/12.0'

# Send STDERR also to LOGFILE
exec 2> >(tee --append "${LOGFILE}")

has_cloudflare() {
    local url="${1}"
    dig SOA +multiline "${url}" | grep cloudflare
    return $?
}

download_and_show() {
    local url="${1}"
    local cmd="${2:-torsocks wget}"
    local errormsg='<span font=\"20px\">feh failed</span>'
    local tmpfile
    tmpfile="$(mktemp --dry-run)"
    nohup >"${LOGFILE}" 2>&1 bash <<<"
    if ! ${cmd} -q -T 60 -O ${tmpfile} -U \"${UA}\" \"${url}\"; then
       notify-send -t 4000 'Error' \"${errormsg}\"
    fi
    feh --image-bg black --scale-down -g 300x300 --class fehi --title=\"${url}\" ${tmpfile} </dev/null
    rm -f ${tmpfile}" &
}

mpv_site() {
    local url="${1}"
    shift
    local OPTS=("${@}")
    nohup >"${LOGFILE}" 2>&1 mpv --ytdl-raw-options=all-subs= \
        --sid=1 \
        --x11-name=mpvFloating \
        --no-terminal \
        --user-agent="${UA}" \
        --af=@rb:rubberband \
        --loop \
        --volume=50 \
        --osd-level=3 \
        "${OPTS[@]}" "${url}" &
}

http_code() {
    local url="${1}"
    curl --user-agent "${UA}" \
        --head --silent \
        --output /dev/null \
        --write-out '%{http_code}' \
        "${url}"
}

case "${URL,,}" in
"")
    echo "ERROR: empty argument :("
    exit 1
    ;;
*.wav* | *.mp3* | *.m4a*)
    mpv_site "${URL}" --player-operation-mode=pseudo-gui
    ;;
*.mov* | *.webm* | *.mp4* | *tiktok.com* | *v.redd.it* | *streamable.com* | *streamja.com*)
    mpv_site "${URL}"
    ;;
*imgflip*) # Does not accept TOR
    download_and_show "${URL}" "wget" ;;
*imgur.com/*)
    if [[ ${URL} != *album* && ${URL} != *jpg && ${URL} != *jpeg && ${URL} != *png ]]; then
        download_and_show "${URL}.jpg"
    fi
    ;&
*.jpg* | *.png* | *.jpeg* | *.webp*)
    download_and_show "${URL}"
    ;;
*.gif)
    nohup >"${LOGFILE}" 2>&1 mpv --no-terminal --loop --osd-level=3 "${URL}" &
    ;;
*.pdf)
    nohup >"${LOGFILE}" 2>&1 evince "${URL}" &
    ;;
*http*://gyazo.com*) # catch things without an extension and add one
    download_and_show "${URL}.jpg" ;;
*news.ycombinator.com*)
    HTTP_PROXY="socks5://127.0.0.1:9050" SPAWNER="$0" \
        hackerview -x -c 100 -t 15s "${URL}"
    ;;
*twitter.com*)
    HTTP_PROXY="socks5://127.0.0.1:9050" SPAWNER="$0" \
        twitterview -x -t 10s -A "${UA}" "${URL}"
    ;;
*lainchan.org*)
    HTTP_PROXY="socks5://127.0.0.1:9050" SPAWNER="$0" \
        vichanview -x "${URL}"
    ;;
*wired-7.org*)
    SPAWNER="$0" \
        vichanview -a=false -x "${URL}"
    ;;
*lobste.rs*)
    SPAWNER="$0" \
        lobstersview -x "${URL}"
    ;;
*reddit.com/r/*)
    HTTP_PROXY="socks5://127.0.0.1:9050" SPAWNER="$0" \
        redditview -x -t 20s "${URL}"
    ;;
*boards.4channel.org* | *boards.4chan.org*)
    # TODO: only supports /g/
    URL="${URL/boards.4channel.org/boards.4chan.org/}"
    if [[ $(http_code "${URL}") -eq 404 ]]; then
        old_cols="$(tput cols)"
        stty cols 80
        w3m -o "user_agent=${UA}" "${URL/boards.4chan.org/desuarchive.org}"
        stty cols "${old_cols}"
    else
        HTTP_PROXY="socks5://127.0.0.1:9050" SPAWNER="$0" \
            fourchanview -x "${URL}"
    fi
    ;;
*linkedin.com*)
    rdrview -B w3m "${URL}"
    ;;
*github.com*)
    torsocks rdrview -B w3m "${URL}"
    ;;
*youtube.com* | *youtu.be*)
    mpv_site "${URL}" --autofit=400x400 --ytdl-format='worst[height>=360]'
    ;;
*twitch.tv*)
    nohup >"${LOGFILE}" 2>&1 streamlink \
        --player mpv \
        --player-args '--autofit=400x400 --no-terminal --af=@rb:rubberband --volume=50 --osd-level=3 --x11-name=mpvFloating' \
        "${URL}" \
        "480p,720p,1080p,worst" &
    ;;
*/t/*)
    HTTP_PROXY="socks5://127.0.0.1:9050" SPAWNER="$0" \
        discourseview -x -t 20s "${URL}"
    ;;
http*)
    domain=${URL#*://}
    domain=${domain%%/*}
    old_cols="$(tput cols)"

    stty cols 80
    if dig SOA +multiline "${domain}" | grep -q cloudflare; then
        rdrview -B w3m "${URL}"
    else
        torsocks rdrview -B w3m "${URL}"
    fi
    stty cols "${old_cols}"
    ;;
*)
    xdg-open "${URL}"
    ;;
esac
