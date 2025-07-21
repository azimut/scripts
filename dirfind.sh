#!/bin/bash
set -eo pipefail
urlview.sh "$(find . -xdev -type f -not -name '*.srt' -and -not -name '*.vtt' | fzf)"
