#!/bin/bash

# Takes lines of either:
# - 1 field
# - 2 fields, comma separated

GNUTERM=dumb gnuplot -e "
unset key;
set size square;
set border 3;
set tics nomirror;
set datafile separator comma;
plot '-'
"
