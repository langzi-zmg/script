for i in {2..9}
do
  for j in {1..31}
  do
     #hadoop fs -rm -r /flume/events/ApplicationActivatedEvent/2018-0$i-0$j
      if [ $j -le 9 ] ;then
         #hadoop fs -rm -r /flume/events/ApplicationActivatedEvent/2018-0$i-0$j
         hadoop fs -rm -r /flume/events/PageViewEvent/2018-0$i-0$j
         hadoop fs -rm -r /flume/events/ReadingStatsEvent/2018-0$i-0$j
         hadoop fs -rm -r /flume/events/ReadingTimeStatsEvent/2018-0$i-0$j
         hadoop fs -rm -r /flume/events/ShareEvent/2018-0$i-0$j
         hadoop fs -rm -r /flume/events/StockActionEvent/2018-0$i-0$j
         hadoop fs -rm -r /flume/events/StockViewEvent/2018-0$i-0$j
         hadoop fs -rm -r /flume/events/UserCopyEvent/2018-0$i-0$j
         hadoop fs -rm -r /flume/events/UserEventV2/2018-0$i-0$j
         #echo "2018-0$i-0$j"
      else
         #hadoop fs -rm -r /flume/events/ApplicationActivatedEvent/2018-0$i-$j
         hadoop fs -rm -r /flume/events/PageViewEvent/2018-0$i-$j
         hadoop fs -rm -r /flume/events/ReadingStatsEvent/2018-0$i-$j
         hadoop fs -rm -r /flume/events/ReadingTimeStatsEvent/2018-0$i-$j
         hadoop fs -rm -r /flume/events/ShareEvent/2018-0$i-$j
         hadoop fs -rm -r /flume/events/StockActionEvent/2018-0$i-$j
         hadoop fs -rm -r /flume/events/StockViewEvent/2018-0$i-$j
         hadoop fs -rm -r /flume/events/UserCopyEvent/2018-0$i-$j
         hadoop fs -rm -r /flume/events/UserEventV2/2018-0$i-$j
         #echo "2018-0$i-$j"
      fi
  done
done
