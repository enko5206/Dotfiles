#!/bin/bash

if [ -z "`grep "open" /proc/acpi/button/lid/LID0/state`" ]; then
        exit 0
fi

MYPATH=`pwd`
mkdir -p /tmp/photo
cd /tmp/photo
mplayer -frames 3 -vo jpeg tv:///dev/video0 >/dev/null 2>/dev/null
cp 00000003.jpg "$MYPATH/`date '+%d.%m.%y %T'`.jpg"
rm 000000??.jpg
cd "$MYPATH"

