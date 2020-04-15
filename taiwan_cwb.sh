#!/bin/bash

mkdir -p ${HOME}/taiwan_cwb/
cd ${HOME}/taiwan_cwb/

enable_curl=true
enable_curl2=true
enable_vid=false
enable_gdrive=false

curl_opts="--silent --show-error"

base_radar=https://www.cwb.gov.tw/Data/radar/
base_temp=https://www.cwb.gov.tw/Data/temperature/
base_precip=https://www.cwb.gov.tw/Data/rainfall/
base_hima=https://www.cwb.gov.tw/V7/observe/satellite/Data/syo/
base_url_him=https://rammb-slider.cira.colostate.edu/data/imagery/

date1=`TZ=GMT+24 date +%Y%m%d`
date2=`TZ=GMT+24 date +%Y-%m-%d`
date_yesterday=`TZ=GMT+48 date +%Y%m%d`

date1=$1$2$3
date2=$1-$2-$3
midnight=`date -d ${date2} +"%s"`
yesterday_t=$((midnight-600))
date_yesterday=`date -d @${yesterday_t} +'%Y%m%d'`

mkdir -p $date2/radar
mkdir -p $date2/temperature
mkdir -p $date2/precip1
mkdir -p $date2/precip2
#mkdir -p $date2/precip_hour
mkdir -p $date2/himawari

if [ "$enable_curl" = true ];
then
	curl ${base_radar}CV1_TW_3600_${date1}[00-23][00-50:10].png -o ${date2}/radar/CV1_TW_3600_${date1}#1#2.png
	curl ${base_temp}${date2}_[00-23][00-00].GTP8.jpg            -o ${date2}/temperature/${date2}_#1#2.GTP8.jpg
	#curl ${base_precip}${date2}_[00-23][00-30:30].EZT.jpg       -o ${date2}/precip_hour/${date2}_#1#2.EZT.jpg
	curl ${base_precip}${date2}_[00-23][00-30:30].QZJ8.jpg       -o ${date2}/precip1/${date2}_#1#2.QZJ8.jpg
	curl ${base_precip}${date2}_[00-23][00-30:30].QZJ8.grd2.jpg  -o ${date2}/precip2/${date2}_#1#2.QZJ8.grd2.jpg
fi

if [ "$enable_curl2" = true ];
then
	echo "Himawari"
	# HIMAWARE in UTC
	# So we need yesterday from 16:00 til 23:59
	# Today from 00:00 til 15:59
	curl -L -H 'User-Agent: Test' \
${base_url_him}${date_yesterday}/himawari---full_disk/geocolor/${date_yesterday}[16-23][00-50:10]00/04/004_005.png -o $date2/himawari/him_${date_yesterday}#1#2.png
        curl -L -H 'User-Agent: Test' \
${base_url_him}${date1}/himawari---full_disk/geocolor/${date1}[00-15][00-50:10]00/04/004_005.png -o $date2/himawari/him_${date1}#1#2.png


#	for hour in {16..23};
#	do
#		for minute in {00..50..10};
#		do
#			url=${base_url_him}${date_yesterday}/himawari---full_disk/geocolor/${date_yesterday}${hour}${minute}00/04/004_005.png
#			echo $url
#			curl $url -H 'User-Agent: Test' > himawari/$date2/him_${date_yesterday}${hour}${minute}.png
#		done
#	done
#	for hour in {00..15};
#	do
#	        for minute in {00..50..10};
#	        do
#	                url=${base_url_him}${date1}/himawari---full_disk/geocolor/${date1}${hour}${minute}00/04/004_005.png
#	                echo $url
#			curl $url -H 'User-Agent: Test' > himawari/$date2/him_${date1}${hour}${minute}.png
#	        done
#	done	
fi
