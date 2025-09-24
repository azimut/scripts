#!/bin/sh
set -e
field="${1:-1}"
separator="${2:-,}"
gnuplot -e "set datafile separator '${separator}'; stats '/dev/stdin' using ${field}"
