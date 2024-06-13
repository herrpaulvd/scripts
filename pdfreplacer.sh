#!/bin/bash
# Before usage do
# > sudo apt install poppler-utils
# > sudo apt install img2pdf

find_file() {
    prefix=$1
    suffix=$2
    if test -e "$prefix$suffix"; then
        echo "$prefix$suffix"
    else
        find_file "$prefix" "0$suffix"
    fi
}

original=$1
replacer=$2
result=$3
replacing_pages=$4

rm cache-*
pdftoppm -png $original cache-o
pdftoppm -png $replacer cache-r

total_pages=$(ls | grep -e 'cache-o-' | sort -n | tail -1)

r=0
for p in $replacing_pages
do
    r=$((r+1))
    cp $(find_file cache-r- $r.png) $(find_file cache-o- $p.png)
done

img2pdf cache-o-*.png -o $result
rm cache-*
