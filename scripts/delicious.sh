#!/bin/sh
# newsbeuter bookmarking plugin for del.icio.us
# (c) 2007 Andreas Krennmair
# documentation: http://delicious.com/help/api#posts_add

username="a"
password="b"

url="$1"
title="$2"
desc="$3"

delicious_url="https://api.delicious.com/v1/posts/add?url=${url}&description=${title}&extended=${desc}"

output="$(wget --user-agent='lupin/sensei' --http-user="${username}" --http-passwd="$password" -O - "$delicious_url" 2> /dev/null)"

output="$(echo "$output" | sed 's/^.*code="\([^"]*\)".*$/\1/')"

if [[ "$output" != "done" ]] ; then
  echo "$output"
fi
