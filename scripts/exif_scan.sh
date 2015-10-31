#!/bin/bash
# Description: extract exif data from images using different tools
# Usage: accept one argument or a list of arguments
# ./exif_scan.sh image.jpg
# ./exif_scan.sh *.jpg
echoname(){
  tput setf 2
  echo '=====> '"$@"
  tput sgr0
}

exif.get(){
  {
    set -x
    exif "$@"
    exif --extract-thumbnail -- "$@"
    exiftool "$@"
    exiftags -a "$@"
    hachoir-metadata --verbose --level=9 --quality=1.0 "$@"
    { set +x; } &> /dev/null
  } 2>&1
}

for img in "$@"; do
  if [[ -f $img ]]; then
    echoname "$img"
    exif.get "$img"
  fi
done
