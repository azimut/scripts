#!/bin/bash
set -eo pipefail
urlview.sh "$(find . -xdev -type f | fzf)"
