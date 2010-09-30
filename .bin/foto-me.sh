#!/bin/bash

if [ -z "`grep "open" /proc/acpi/button/lid/LID0/state`" ]; then
        exit 0
fi

mkdir -p /tmp/photo
cd /tmp/photo
mplayer -frames 3 -vo jpeg tv:///dev/video0 >/dev/null 2>/dev/null
cd -
cp /tmp/photo/00000003.jpg "`date '+%d.%m.%y %T'`.jpg"
rm /tmp/000000??.jpg
