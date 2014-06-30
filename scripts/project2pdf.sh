#!/bin/bash

[[ ! -d $1 ]] && exit 1

project_dir=$( readlink -en $1 )

# mirror project dir 
rm -rf ${project_dir}_pdf/ 
mkdir -p ${project_dir}_pdf/

cd ${project_dir} && {
  for file in $( find . -type f ); do
    filename=${file##*/}
    filepath=${file%/*}
    [[ $( file --mime-type -b ${file} | cut -f1 -d/ ) != 'text' ]] && continue
    mkdir -p ${project_dir}_pdf/${filepath}
    pygmentize -l bash -O full -f html "${file}" | wkhtmltopdf - "${project_dir}"_pdf/"${filepath}"/"${filename%.*}".pdf
  done
}
