#!/bin/bash
namespace=$1
pod_name=$2
container_name=$3

if kubectl get pods -n $namespace $pod_name
then
  reason=`kubectl describe pods -n $namespace $pod_name | grep "Reason:" | cut -d : -f 2`
if [ $reason ];
then
if [ '$reason' = 'OOMKilled' ];
then
  echo  The reason of $pod_name restart is $reason.
elif [ '$reason' = 'Error' ];
then
  echo The reason of $pod_name restart is code panic...
  ip=`kubectl get pods -n $namespace -o wide | grep $pod_name | awk '{print $7}'`
  echo $ip
  server_name=`echo $2 | cut -d - -f 1`
  echo $server_name
  container_id=`ssh $ip sudo docker ps -a | grep $server_name | grep "Exited" | grep -v "p47-sidecar" | grep -v "nginx" | grep -v "pause" | awk '{print $1}'`
  echo $container_id
  log_path=/opt/docker/containers/$container_id*
  echo $log_path
  echo now...get in the mother node

  ssh $ip
else
  echo This reason $reason is not OOMKilled or panic Error ,please manual inspection.
fi
else
  echo pods $pod_name is running
fi
else
  echo pods $pod_name not found
fi
