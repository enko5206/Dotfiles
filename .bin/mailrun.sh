#!/bin/sh

PID=`pgrep offlineimap`

[ -n "$PID" ] && kill $PID

offlineimap &

exit 0
