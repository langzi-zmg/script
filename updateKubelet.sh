#!/bin/bash

set -e

kubelet_unit_path="/usr/lib/systemd/system/kubelet.service"
kubelet_conf_path="/etc/kubernetes/kubelet"

declare -A kubelet_paras=(
  ["FEATURE_GATES"]="--feature-gates=StartupProbe=true"
)

update_kubelet_unit(){
  for key in ${!kubelet_paras[@]}; do
    if grep -q -w ${key} ${kubelet_unit_path} ; then
      continue
    fi
    sed -i '/ExecStart=/s/$/& ${'${key}'}/' ${kubelet_unit_path}
  done
}

update_kubelet_conf(){ 
 for key in ${!kubelet_paras[@]}; do
     if grep -q -w ${key} ${kubelet_conf_path} ; then
         sed -i "/\<${key}\>/ d" $kubelet_conf_path
     fi
     echo "${key}=\"${kubelet_paras[${key}]}\"" >> $kubelet_conf_path
 done
}

update_kubelet_conf
update_kubelet_unit
systemctl daemon-reload
systemctl restart kubelet.service
