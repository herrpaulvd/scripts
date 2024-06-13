#!/bin/bash
# Before usage do
# > sudo apt install poppler-utils
# > sudo apt install img2pdf
# > sudo apt install ghostscript

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

r=0
for p in $replacing_pages
do
    r=$((r+1))
    cp $(find_file cache-r- $r.png) $(find_file cache-o- $p.png)
done

img2pdf cache-o-*.png -o cache-pdf.pdf
gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/screen -dNOPAUSE -dQUIET -dBATCH -sOutputFile=$result cache-pdf.pdf
rm cache-*
