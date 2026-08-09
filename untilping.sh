#!/bin/bash
set -e

trap 'echo -n "Ending at: "; date "+%H:%M:%M.%N"' EXIT

usage() {
    echo "ICMP echo ping given host until is alive."
    echo -e "Usage:\n\t$(basename $0) HOST"
}
(($# != 1)) && usage && exit 1

echo -n "Starting at: "; date '+%H:%M:%M.%N'
until ping -c 1 "$1" > /dev/null; do
    echo -n "."
    sleep 1 # also helps with ^C
done
