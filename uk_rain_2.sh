#!/bin/bash
year=`TZ=GMT+24 date +'%Y'`
month=`TZ=GMT+24 date +'%m'`
day=`TZ=GMT+24 date +'%d'`

echo $year-$month-$day $1-$2

uk_rain.sh $year $month $day $1 $2
