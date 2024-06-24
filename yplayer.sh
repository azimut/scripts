#!/bin/bash

TEMP_FILE=$(mktemp)
YOUTUBE_DL_OPTIONS=(-f 18)

ctrl_c(){
  set -x
  rm -f $TEMP_FILE
  kill $queue_pid
  exit 1
}

trap ctrl_c SIGINT

echoerr()  { echo -en '\x1b[31;01m[-]\x1b[39;49;00m ' 1>&2; echo "$@" 1>&2; }

check_in_path(){
  local cmd=$1
  hash "$cmd" &>/dev/null || {
    echoerr "uError: command \"$cmd\" not found in \$PATH, please add it or install it..."
    exit 1
  }
}

check_in_path 'mpv'
check_in_path 'youtube-dl'

# Description: launch a mpv process
# INPUT: normal url of a video
# OUTPUT: none
yplayer(){
  local yurl=$1
  local regex_y_video='^http://.*'
  local y_video

#  set -x
  until [[ ! -z "$(pgrep mpv)" ]]; do
    mpv --volume=25 \
        --no-resume-playback \
        --framedrop=vo \
        --ytdl \
        -ao jack \
        --ytdl-format 18 "${yurl}" </dev/null > /dev/null 2>&1 &
  
    disown
    sleep 10 # idle time to make sure the mpv process didn't died
#    set +x
  done
}

# Description: if no "mpv" process is found, send the url to the function in charge of spawn mpv
# INPUT: none / pgrep mpv
# OUTPUT: none
queue(){
  while :; do
    if [[ -z "$(pgrep mpv)" &&  -s $TEMP_FILE ]]; then
      yplayer "$(head -n1 $TEMP_FILE)"
      sed -i '1d' $TEMP_FILE
    fi
    sleep 5 # <--- idle time between each queue check
  done
}

# fork the function that watch the queue
queue &
queue_pid=$! # obtain the PID of the queue

# Description: "UI" that waits for user input
# INPUT: keyboard
# OUTPUT: temporary file
while :; do
  read -r -p 'Provide a valid youtube URL: ' yurl
  echo "${yurl}" | cut -f1 -d'&' >> $TEMP_FILE
done
