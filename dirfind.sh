#!/bin/bash
set -eo pipefail
find . -xdev -type f | fzf | xargs -r urlview.sh
