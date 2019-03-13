#!/bin/sh

event=(ApplicationActivatedEvent ApplicationMinimizeEvent ControlClickedEvent GlobalChannelListElementClickEvent LoginEvent PageViewEvent ReadingStatsEvent ReadingTimeStatsEvent ShareEvent StockActionEvent StockViewEvent UserCopyEvent UserEventV2 RecFeedClickEvent RecFeedRefreshEvent 	RegistrationEvent SuccessOrderEvent TerminalClickEvent Page_AppearEvent)

for i in {10..12}
do
  for j in {1..31}
  do
     #hadoop fs -rm -r /flume/events/ApplicationActivatedEvent/2018-0$i-0$j
      if [ $j -le 9 ] ;then
 	 for m in ${event[@]};do
	 hadoop fs -rm -r /flume/events/$m/2018-$i-0$j
         done
      else
         for n in ${event[@]};do
         hadoop fs -rm -r /flume/events/$n/2018-$i-$j
         done
      fi
  done
done
