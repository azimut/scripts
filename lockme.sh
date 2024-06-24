#!/bin/bash

# dependency: imagemagick, scrot

# https://faq.i3wm.org/question/83/how-to-run-i3lock-after-computer-inactivity/
scrot /tmp/screen_locked.png
convert /tmp/screen_locked.png -scale 10% -scale 1000% /tmp/screen_locked2.png
i3lock -i /tmp/screen_locked2.png
