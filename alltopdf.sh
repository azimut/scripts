#!/bin/bash

[[ ! -d $1 ]] && exit 1

project_dir=$( readlink -en $1 )
files=()

cd ${project_dir} && {
  while read -r file; do
    filename=${file##*/}
    filepath=${file%/*}
    [[ $( file --mime-type -b ${file} | cut -f1 -d/ ) != 'text' ]] && continue
    files+=("${file}")
  done < <(find . -type f)
  pygmentize -l bash -O full -f html <(cat "${files[@]}") | wkhtmltopdf - all.pdf
}
