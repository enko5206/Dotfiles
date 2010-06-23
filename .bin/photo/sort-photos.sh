#!/bin/bash

# (1)
if [[ $1 == "-h" || $1 == "--help" ]]; then
   echo "usage: $0 [-d] [name suffix]"
   echo "option -d create directories for each day";
   exit;
fi

# (2)
CREATE_DIR=0
if [[ $1 == "-d" ]]; then CREATE_DIR=1; shift; fi

# (3)
for f in *.jpg *.JPG; do

   # (4)
   if [[ $f == "*.jpg" || $f == "*.JPG" ]]; then continue; fi
  
   # (5)
   DATETIME=$(exif -i "$f" | grep 0x9003 | sed -r 's/.*\|//; s/:/-/g; s/ *$//')
   DATE=$(exif -i "$f" | grep 0x9003 | sed -r 's/.*\|//; s/:/-/g; s/ *$//; s/ .*$//')
   if [[ $DATE == "" || $DATETIME == "" ]]; then continue; fi

   # (6)
   [[ ! -d $DATE && $CREATE_DIR == "1" ]] && mkdir -p $DATE
   echo $f

   # (7)
   DST="${DATETIME}${1}.jpg"
   if [[ $CREATE_DIR == "1" ]]; then DST="$DATE/${DATETIME}${1}.jpg"; fi

   # (8)
   mv "$f" "$DST"
done
