#!/bin/bash
echo -n "16:9 -"
for ((i = 10; i < 150; i = i + 10)); do
    printf " %dx%d" $((16 * i)) $((9 * i))
done
echo
echo -n " 4:3 -"
for ((i = 40; i < 400; i = i + 20)); do
    printf " %dx%d" $((4 * i)) $((3 * i))
done
echo
