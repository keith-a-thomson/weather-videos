#!/bin/bash

if [ "$1" = "tomorrow" ];
then
	year=`TZ=GMT-24 date +'%Y'`
	month=`TZ=GMT-24 date +'%m'`
	day=`TZ=GMT-24 date +'%d'`
fi

if [ "$1" = "today" ];
then
	year=`date +'%Y'`
	month=`date +'%m'`
	day=`date +'%d'`
fi


echo $year-$month-$day $2-$3

taiwan_radar.sh $year $month $day $2 $3
