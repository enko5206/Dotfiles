#!/bin/bash
mkdir resize_foto;
for f in *.JPG; do
    echo $f
	convert -quality 85 -resize 1280x800 "$f" "resize_foto/${f%.jpg}-resize.jpg" ;
	#tar cf resize_foto.tar resize_foto ;
done
