#!/usr/bin/python
import json
import time
from collections import Counter

c = Counter()
i = 1
#f = open('ivankagateway.20170411.172_16_31_13.log')
#f = open('ivankagateway.20170413.172_16_31_11.log')
#f = open('ivankagateway.20170409.172_16_31_12.log')
#f = open('ivankagateway.20170410.172_16_31_12.log')
f = open('ivankagateway.20170413.172_16_31_12.log')
while True:
    file = f.readline()
    try:
        result = json.loads(file)
        ip = result['remote_ip']
        c.update({ip:1})
        i+=1
        if i%10000 == 0:
            print c.most_common(10)
    except: continue

