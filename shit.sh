#!/bin/bash
 coscmd download -r /flume/events/$1/   /data/$1/
cd /data/$1/
for i in `ls`;do for j in `ls $i`;do mv -f $i/$j $i/`echo "hour="$j`;done;mv -f $i `echo "dt="$i`;done
coscmd upload -r /data/$1/  events/ev=$2/
