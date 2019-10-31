#!/bin/bash
mkdir -p ${HOME}/uk_rain
cd ${HOME}/uk_rain

enable_curl=true
base_url=https://max.nwstatic.co.uk/tiles3/

date1=$1$2$3
date2=$1-$2-$3

mkdir -p $date2
cd $date2

# Full zoom
#curl  --create-dirs --show-error ${base_url}${date1}/[00-23][00-55:5]/9/[120-130]/[72-85].png -o "#1#2/#4_#3.png"

# Zoom 8
curl -f -s --retry 5 --retry-delay 5 --retry-max-time 60 --create-dirs --show-error ${base_url}${date1}/[$4-$5][00-55:5]/8/[59-66]/[37-44].png -o "#1#2/#4_#3.png"

cd ..

uk_rain_missing.sh $1 $2 $3 $4 $5
#cd $date2
#echo "Find"
#find  -type f -size -2k | xargs file | grep -v PNG 
# cut -d ':' -f 1 | xargs -r rm
#cd ..


# Background image
#mkdir -p osm
#cd osm
#curl https://b.tile.openstreetmap.org/8/[118-133]/[74-89].png -o "#2_#1.png"
#magick.exe montage *.png -geometry +0+0 -tile 16x ../osm.png
#cd ..

