#!/bin/python-32

import json
filename = '/Users/zhangmengege/Downloads/provision'
outputname = '/Users/zhangmengege/Downloads/provision.csv'
with open(filename, 'r', encoding='utf8') as f:
    data = json.load(f)
hits_list = data['hits']['hits']
result = []
for d in hits_list:
    msg = d['_source']['msg']
    msg_list = msg.split(':')
    timestamp = d['_source']['@timestamp']
    line_list = msg_list + [timestamp]
    result.append(line_list)
result_str = '\n'.join([','.join(line) for line in result])
with open(outputname, 'w', encoding='utf8') as f:
    f.write(result_str)
