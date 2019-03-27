#!/bin/bash
hivePath="/usr/local/service/hive/bin/hive"
table=(application_activated control_click pageview readingstats share_event)

if [ $# == 2 ]; then
    datebeg=$1
    dateend=$2
else
    echo "请输入开始时间和结束日期，格式为2017-04-04"
    exit 1
fi

beg_s=`date -d "$datebeg" +%s`
end_s=`date -d "$dateend" +%s`
echo "处理时间范围：$beg_s 至 $end_s"

echo "create PARTITION........."
while [ "$beg_s" -le "$end_s" ];do
    day=`date -d @$beg_s +"%Y-%m-%d"`;
    beg_s=$((beg_s+86400));
    for i in ${table[@]}
    do
    for j in {0..23}
    do
    if [ $j -le 9 ];then
    $hivePath -e 'set hive.execution.engine=mr;use bi;alter table '$i' ADD PARTITION (dt='\"$day\"',hour='\"0$j\"')'
    else
    $hivePath -e 'set hive.execution.engine=mr;use bi;alter table '"$i"' ADD PARTITION (dt='\"$day\"',hour='\"$j\"')'
    fi
    done
    done
done
echo "全部处理完成"
