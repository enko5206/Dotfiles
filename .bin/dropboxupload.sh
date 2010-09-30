#!/bin/bash
#
# Nautilus script -> Upload to Dropbox
#
     
DBDIR=~/Dropbox/Public
ID=1
     
if [ -e "$1" ]
then
    cp -f "$1" "$DBDIR"
    file=`basename "$1"`
    link="http://dl.getdropbox.com/u/$ID/$file"
    notify-send -i go-down "Upload to Dropbox" "Ссылка на \"$file\" скопирована в буфер обмена"
    echo "$link" | xsel -bi
else
    notify-send -i go-down "Upload to Dropbox" "Выберите файл!"
fi


