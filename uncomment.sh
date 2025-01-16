#!/bin/sh

sed '/^\s*#/d;/^$/d' "${1:-/dev/stdin}"
