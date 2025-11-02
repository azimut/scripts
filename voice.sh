#!/bin/bash

trap 'kill "${VOICE_PID}"' EXIT

coproc VOICE {
    while read -r phrase; do
        spd-say --wait -l es "${phrase}"
    done
}

rlwrap cat >&"${VOICE[1]}"
