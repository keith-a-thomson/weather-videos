#!/bin/bash

txtfunc() {
	cp $1.prev.jpg t_$1.prev.jpg # Copy the last image from yesterday to a temporary one
	prev="t_$1.prev.jpg" # Use the previous stored version e.g. if no current image available

	echo "Scanning ${name}"
	for hour in {00..23}
	do
		for minute in {00..59..5}
		do
			filename=${date}/${name}_${date2}_${hour}${minute}.jpg
			type=`file ${filename} | grep -v "image data"`
			if [ ! -f ${filename} ] || [ ! -z "$type" ];
			then
				echo -e "file '$prev'\nduration 0.1" >> $2;
			else
				echo -e "file '${filename}'\nduration 0.1" >> $2;
				prev=${filename}
			fi
		done
	done
	cp $prev "$1.prev.jpg" # Set the last image as the "previous" for tomorrows run
}

if [ "$#" -ne 3 ];
then
	echo "Wrong number of inputs"
	exit 0
fi

date=$1-$2-$3
date2=$1$2$3
cd ${HOME}/cairngorms/

declare -a arr=(
        "glenshee"
        "lecht"
        "breamar"
        "glendye"
        "spittal"
        "cockbridge"
        "a93south"
        "a93north"
        #"lochmorlich"
        #"sunkid"
        #"whitelady"
        #"fiacaill"
		#"base"
		#"cottams"
		#"gunbarrel"
		#"lowercarpark"
		#"maincarpark"
		#"zigzags"
)

for name in "${arr[@]}"
do
	rm -rf ${name}.txt
	txtfunc ${name} ${name}.txt
done

ffmpeg \
	-f concat -safe 0 -r 24 -i glenshee.txt \
	-f concat -safe 0 -r 24 -i lecht.txt  \
	-f concat -safe 0 -r 24 -i breamar.txt  \
	-f concat -safe 0 -r 24 -i glendye.txt  \
	-f concat -safe 0 -r 24 -i spittal.txt  \
	-f concat -safe 0 -r 24 -i cockbridge.txt  \
	-f concat -safe 0 -r 24 -i a93south.txt  \
	-f concat -safe 0 -r 24 -i a93north.txt  \
	-filter_complex \
	"[0:v]scale=3840:-1,pad=iw:2160[glenshee],
	[1:v]scale=3840:-1[lecht],
	[2:v]scale=640:-1[breamar],
	[3:v]scale=640:-1[glendye],
	[4:v]scale=640:-1[spittal],
	[5:v]scale=640:-1[cockbridge],
	[6:v]scale=-1:-1[a93south],
	[7:v]scale=-1:-1[a93north],
	[glenshee][lecht]overlay=0:overlay_h[AA],
	[AA][breamar]overlay=0:1560[BB],
	[BB][glendye]overlay=640:1560[CC],
	[CC][cockbridge]overlay=1280:1560[DD],
	[DD][spittal]overlay=1920:1560[EE],
	[EE][a93south]overlay=2560:1560[FF],
	[FF][a93north]overlay=3200:1560[out]" \
	-map "[out]" \
	-vcodec libx265 \
	-movflags +faststart \
	-pix_fmt yuv420p \
	-crf 10 -preset slow \
	-r 24 \
	${date2}_glenshee_lecht.mp4

for name in "${arr[@]}"
do
	rm t_${name}.prev.jpg
	rm ${name}.txt
done
