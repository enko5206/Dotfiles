#!/bin/bash
DIR=/mnt/data/Images/screenshots`date +%d.%m.%y`
if [ ! -d $DIR ]; then mkdir $DIR; fi
file=$DIR"/`date '+%d-%m%y-%N'`".png;
sleep 6 && scrot -q 85 "$file"
xmessage -center -buttons "Local View:1,Send to Internet:2,Cancel:3" "$file"
exitcode=$?
case "$exitcode" in
        #View: local-copy with image-viewer
        [1]   )
        gpicview "$file";;
        #Send: send to internets
        [2]   )
        LINK=`curl --silent -F "image"=@"$file" -F "key"="5d317f0bee23b282473522e1aa68f621" http://imgur.com/api/upload.xml | grep -Eo 'http://i.imgur.com/[a-zA-Z0-9.]+.[a-zA-Z]+' | head -1`
        rm "$file";
        xmessage -center "$LINK";;
        # Exit: remove local file
        [3]   ) rm "$file";;
esac
