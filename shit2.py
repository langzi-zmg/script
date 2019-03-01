#!/usr/bin/python
# -*- coding: UTF-8 -*-

import sys
import commands

topicName=sys.argv[1]
newName=sys.argv[2]
list = ("coscmd list flume/events/%s/ | awk '{print $1}' |  head -n -1"%(topicName))
return_code, output = commands.getstatusoutput(list)
output=output.split("\n")
for i in output:
    str=i.split("/")
    date=str[3]
    for j in range(0,24):
        copycmd = ("coscmd copy -r bigdata-1252820405.cos.ap-shanghai.myqcloud.com/%s%s/ /events/ev=%s/dt=%s/hour=%s/"%(i,"%02d" % j,newName,date,"%02d" % j))
        return_code, output = commands.getstatusoutput(copycmd)
        print output
