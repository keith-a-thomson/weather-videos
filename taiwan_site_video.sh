#!/bin/bash

if [ "$#" -ne 3 ];
then
        echo "Run as taiwan_site_video.sh yyyy mm dd"
        exit 0
fi

date=$1$2$3
date_=$1-$2-$3

cd ${HOME}/taiwan_radar/

for station in CV1_RCLY_1000 CV1_RCNT_1000 CV1_RCSL_1000;
do
	ffmpeg -hide_banner -f image2 \
	       -pattern_type glob -i ${STATION}_${date}'*.png' \
		   -vf "pad=1080:1080:40:40" \
		   -vcodec libx265 -crf 10 -pix_fmt yuv420p \
		   ${station}_${date}.mp4
done