# -*- coding: utf-8 -*-
from qiniu import Auth
from qiniu import BucketManager
import json

access_key = '**'
secret_key = '**'

q = Auth(access_key, secret_key)
bucket = BucketManager(q)

bucket_name = 'baoer'
# 前缀
prefix = 'user_'
# 列举条目
limit = 1000
# 列举出除'/'的所有文件以及以'/'为分隔的所有前缀
delimiter = None
# 标记
marker = None

def getItems(marker):
    ret, eof, info = bucket.list(bucket_name, prefix,marker , limit, delimiter)
    if ret.has_key('marker'):
        marker = ret["marker"]
        items = ret["items"]
        for i in items:
            print(i["key"].encode("utf-8"))
        return getItems(marker)

#ret, eof, info = bucket.list(bucket_name, prefix,marker , limit, delimiter)
#market = ret["marker"]
#items = ret["items"]
#for i in items:
#    print(i["key"])
getItems(marker)
