#!/bin/bash
#Remove the exited container
apt install jq -y > /dev/null 2>&1
runc=`docker-runc list -q`
docker_list=`docker inspect $(docker ps -a -q) | jq .[].Id | tr -d '"'`
dirty=`echo $runc $docker_list | tr ' ' '\n' | sort | uniq -u`
for var in ${dirty}
do
    echo $var
    nsenter -t `docker-runc state $var | jq .pid` -n ip link del eth0
    docker-runc kill $var SIGKILL
done

