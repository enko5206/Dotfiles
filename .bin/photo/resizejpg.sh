#!/bin/sh
mkdir resize_foto;
for f in *.jpg ; do
	convert -quality 85 -resize 1280x800 "$f" "resize_foto/${f%.JPG}-resize.JPG" ;
	#tar cf resize_foto.tar resize_foto ;
done
