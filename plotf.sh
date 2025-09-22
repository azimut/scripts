#!/bin/sh

GNUTERM=dumb gnuplot -e "
unset key;
unset border;
set tics nomirror axis;
set datafile separator comma;
set style data boxes;
set style fill solid border -1;
width = ${1:-1000};
bin(x,width) = width * floor(x / width);
plot '-' using (bin(\$1,width)) smooth freq;
"
