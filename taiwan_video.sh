txtfunc() {
	prev="$2.prev" # Use the previous stored version e.g. if no current image available
	for i in $1;
	do 
		type=`file $i | grep -v "image data"`
		if [ ! -f $i ] || [ ! -z "$type" ];
		then
			echo -e "file '$prev'\nduration 0.1" >> $2;
		else
			echo -e "file '$i'\nduration 0.1" >> $2;
			prev=$i
		fi
	done
	cp $prev "$2.prev"
}

cd ${HOME}/taiwan_cwb/

#date1=`date +'%Y%m%d'`
#date2=`date +'%Y-%m-%d'`
#date_yesterday=`TZ=GMT+24 date +%Y%m%d`

date1=$1$2$3
date2=$1-$2-$3

rm -f radar.txt precip1.txt precip2.txt temp.txt him.txt
txtfunc "${date2}/radar/*.png" radar.txt
txtfunc "${date2}/precip1/*.jpg" precip1.txt
txtfunc "${date2}/precip2/*.jpg" precip2.txt
txtfunc "${date2}/temperature/*.jpg" temp.txt
txtfunc "${date2}/himawari/*.png" him.txt

ffmpeg \
	-f concat -safe 0 -r 24 -i radar.txt \
	-f concat -safe 0 -r 8 -i precip1.txt \
	-f concat -safe 0 -r 8 -i precip2.txt \
	-f concat -safe 0 -r 4 -i temp.txt \
	-f concat -safe 0 -r 24 -i him.txt \
	-filter_complex \
	"[0:v]scale=-1:1080,pad=1920:ih[t],[t][4]overlay=1080[p],[p][1]overlay=1120:680[q],[q][2]overlay=1520:680[r],[r][3]overlay=1520:280[out]" \
	-map "[out]" \
	-vcodec libx265 \
	-movflags +faststart \
	-pix_fmt yuv420p \
	-crf 0 -preset slow \
	-r 24 \
	${date1}_radar.mp4

#      -profile:v high  -level 4.0 -bf 2 -g 12 -coder 1 -crf 18

rm -f radar.txt precip1.txt precip2.txt temp.txt him.txt
