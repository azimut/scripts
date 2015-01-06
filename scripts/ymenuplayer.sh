#!/bin/bash

TEMP_FILE=$(mktemp)

ctrl_c(){
  set -x
  rm -f $TEMP_FILE
  [[ -n $queue_pid ]] && kill $queue_pid
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
  local y_video="$1"

  # keep going until a mpv/youtube-dl process is found running
  until [[ ! -z "$(pgrep mpv)" ]]; do
    mpv --volume=25 "${y_video}" </dev/null >/dev/null 2>&1 &
    disown
    sleep 10 # idle time to make sure the mpv process didn't died
  done
}

# Description: if no "mpv" process is found, send the url to the function in charge of spawn mpv
# INPUT: none / pgrep mpv
# OUTPUT: none
queue(){
  while :; do
    if [[ -z "$(pgrep mpv)" &&  -s $TEMP_FILE ]]; then
      # read the first element of the queue
      yplayer "$(head -n1 $TEMP_FILE | cut -f3 -d$'\31')"
      # delete the first element of the queue
      sed -i '1d' $TEMP_FILE
    fi
    sleep 5 # <--- idle time between each queue check
  done
}

add_to_queue(){
  local y_url="$1"
  until [[ ! -z ${y_data[@]} ]]; do
    mapfile -t y_data < <(youtube-dl -e -g -f 18 "${y_url}")
    wait #?
    printf '%s\31%s\31%s' "$y_url" "${y_data[0]}" "${y_data[1]}" >> $TEMP_FILE
  done
}

# fork the function that watch the file/queue
queue &
queue_pid=$! # obtain the PID of the queue

# Description: "UI" that waits for user input
# INPUT: keyboard
# OUTPUT: temporary file
url_regex='http[s]?://www.*'

while :; do
  mapfile -t y_titles < <(cat $TEMP_FILE | cut -f2 -d$'\31')
  select y_title in "${y_titles[@]}" refresh; do
    if [[ $REPLY =~ $url_regex ]]; then
      add_to_queue "${REPLY%%&*}" &
    fi
  done
  unset y_titles
done
