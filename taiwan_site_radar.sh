#!/bin/bash
source common.sh
echo ${GLOBAL_CURL_OPTS}
testfunc INPUT

mkdir -p ${HOME}/taiwan_radar/
cd ${HOME}/taiwan_radar/


exit 0
curl -s https://www.cwb.gov.tw/Data/js/obs_img/Observe_radar_rain.js | grep _1000 | cut -d "'" -f 2 > temp.js

INDEX=0
declare -a FILEARRAY
while read line; do
	if [ ! -f ${line} ]
	then
		FILEARRAY[$INDEX]=${line}
		INDEX=$(( $INDEX + 1 ))
	fi
done < "temp.js"
rm temp.js

chunk=`echo ${FILEARRAY[*]}| tr ' ' ,`
curl -s --create-dirs https://www.cwb.gov.tw/Data/radar_rain/{${chunk}} -o "#1"
