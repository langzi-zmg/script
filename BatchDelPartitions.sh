#!/bin/sh


if [ $# == 3 ]; then
    begin_date=`date -d "+0 day $2" +%Y-%m-%d`
    end_date=`date -d "+0 day $3" +%Y-%m-%d`
    date=${end_date}
    sql=''
    while [[ "${date}" > "${begin_date}" || "${date}" = "${begin_date}" ]]
          do
              echo $date
              sql=${sql}"ALTER TABLE $1 DROP IF EXISTS PARTITION(dt = '$date');"
              echo ${sql}
              date=`date -d "$date -1 days" +"%Y-%m-%d"`
          done
    echo "hive -e '${sql}' "
    hive -e "${sql}"
elif [ $# == 1 ]; then
    date=`date -d -1days '+%Y-%m-%d'`
    echo "hive -e 'ALTER TABLE $1 DROP IF EXISTS PARTITION(dt = '$date');'"
    hive -e "ALTER TABLE $1 DROP IF EXISTS PARTITION(dt = '$date');"
else
    echo 'Parameter error!'
fi
