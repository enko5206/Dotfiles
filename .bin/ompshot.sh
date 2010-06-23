#!/bin/bash
FILE=`date +"%Y-%m-%d-%s".png`

import -window root /home/$USER/$FILE
URL="http://omploader.org"`curl -s -F file1=@/home/$USER/$FILE http://omploader.org/upload | grep -o -m 1 "/v[A-Za-z0-9+\/]*"`
xmessage "Screenshot send" "Firefox: $URL"
