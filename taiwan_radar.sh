#!/bin/bash

mkdir -p ${HOME}/taiwan_cwb/
cd ${HOME}/taiwan_cwb/

curl_opts="--silent --show-error"

base_radar=https://www.cwb.gov.tw/Data/radar/

date1=$1$2$3
date2=$1-$2-$3

mkdir -p $date2/radar
mkdir -p $date2/radar_extended_1000
curl ${base_radar}CV1_TW_3600_${date1}[$4-$5][00-50:10].png -o ${date2}/radar/CV1_TW_3600_${date1}#1#2.png
curl ${base_radar}CV1_1000_${date1}[$4-$5][00-50:10].png -o ${date2}/radar_extended_1000/CV1_1000_${date1}#1#2.png
