#!/bin/sh
# Description: Takes 1 or 2 fields, comma separated.
set -e
GNUTERM=dumb gnuplot -e "
unset key;
set size square;
set border 3;
set tics nomirror scale 0;
set datafile separator comma;
plot '-' pointtype 0;
"
