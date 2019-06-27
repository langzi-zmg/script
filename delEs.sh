#!/bin/bash
CLEAN_LOG="/var/log/clean_es_index.log"
SERVER_PORT=10.1.4.5:9200
INDEXS=$(curl -s "${SERVER_PORT}/_cat/indices?v" |awk 'NR == 1 {next} {print $3}'| grep -v  kibana)
DELTIME=5
SECONDS=$(date -d  "$(date  +%F) -${DELTIME} days" +%s)
echo $SECONDS
echo "----------------------------clean time is $(date +%Y-%m-%d_%H:%M:%S) ------------------------------" >>${CLEAN_LOG}
for del_index in ${INDEXS}
do
    echo ${del_index}
    indexDate=$( echo ${del_index} |cut -d "-" -f 2 )
    format_date=$(echo ${indexDate}| sed 's/\.//g')
    indexSecond=$( date -d ${format_date} +%s )
    gt=${SECONDS}-${indexSecond}
    if [[ ${gt} -gt 0 ]]
        then
        echo "${del_index}" >> ${CLEAN_LOG}
        delResult=`curl -s  -XDELETE "${SERVER_PORT}/"${del_index}"?pretty" |sed -n '2p'`
        echo "clean time is $(date)" >>${CLEAN_LOG}
        echo "delResult is ${delResult}" >>${CLEAN_LOG}
    fi
done
