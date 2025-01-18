#!/bin/bash
set -eo pipefail

usage() {
    echo -e "Scrapes for URL archives in ghostarchive.\n"
    echo -e "Usage:\n\t$(basename "$0") URL"
}
(($# != 1)) && usage && exit 1

url=${1%#*} # remove fragment
response="$(curl -Gs --data-urlencode "term=${url}" 'https://ghostarchive.org/search')"
if [[ ${response} == *"No archives for that site"* ]]; then
    echo "No results found :(" 2>&1
    exit 2
fi

pr -JmtS"  " \
    <(pup 'tr a text{}' <<<"${response}" | gawk -SvZ="${url}" '{ print "\033["($0 != Z?"38;5;243":"0")"m" }') \
    <(pup 'tr:nth-child(n+2) td:nth-child(3) text{}' <<<"${response}" | gawk -S 'NF>0 { print $3"/"substr($4,3) }') \
    <(pup 'tr a attr{href}' <<<"${response}" | sed --sandbox 's#^#https://ghostarchive.org#') \
    <(pup 'tr a text{}' <<<"${response}")
