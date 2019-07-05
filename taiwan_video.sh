txtfunc() {
	prev=
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
}

cd ${HOME}/taiwan_cwb/

#date1=`date +'%Y%m%d'`
#date2=`date +'%Y-%m-%d'`
#date_yesterday=`TZ=GMT+24 date +%Y%m%d`

date1=$1$2$3
date2=$1-$2-$3

#rm -rf /tmp/tcwbradar*
#rm -rf /tmp/tcwbprecip*
#rm -rf /tmp/tcwbtemperature*
#rm -rf /tmp/tcwbhimawari*

#x=0; for i in radar/${date2}/*.png;       do counter=$(printf %04d $x); cp "$i" /tmp/tcwbradar_"$counter".png;       x=$(($x+1)); done
#x=0; for i in precip1/${date2}/*.jpg;     do counter=$(printf %04d $x); cp "$i" /tmp/tcwbprecip1_"$counter".jpg;     x=$(($x+1)); done
#x=0; for i in precip2/${date2}/*.jpg;     do counter=$(printf %04d $x); cp "$i" /tmp/tcwbprecip2_"$counter".jpg;     x=$(($x+1)); done
#x=0; for i in temperature/${date2}/*.jpg; do counter=$(printf %04d $x); cp "$i" /tmp/tcwbtemperature_"$counter".jpg; x=$(($x+1)); done
#x=0; for i in himawari/${date2}/*.png;    do counter=$(printf %04d $x); cp "$i" /tmp/tcwbhimawari_"$counter".png;    x=$(($x+1)); done
rm -f radar.txt precip1.txt precip2.txt temp.txt him.txt
#for i in radar/${date2}/*.png;       do echo -e "file '$i'\nduration 0.1" >> radar.txt;done
#for i in precip1/${date2}/*.jpg;     do echo -e "file '$i'\nduration 0.1" >> precip1.txt;done
#for i in precip2/${date2}/*.jpg;     do echo -e "file '$i'\nduration 0.1" >> precip2.txt;done
#for i in temperature/${date2}/*.jpg; do echo -e "file '$i'\nduration 0.1" >> temp.txt;done
#for i in himawari/${date2}/*.png;    do echo -e "file '$i'\nduration 0.1" >> him.txt;done
txtfunc "radar/${date2}/*.png" radar.txt
txtfunc "precip1/${date2}/*.jpg" precip1.txt
txtfunc "precip2/${date2}/*.jpg" precip2.txt
txtfunc "temperature/${date2}/*.jpg" temp.txt
txtfunc "himawari/${date2}/*.png" him.txt

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
#
#rm -rf /tmp/tcwbradar*
#rm -rf /tmp/tcwbprecip*
#rm -rf /tmp/tcwbtemperature*
#rm -rf /tmp/tcwbhimawari*
rm -f radar.txt precip1.txt precip2.txt temp.txt him.txt

#echo "file '${date1}_radar.mp4'" >> join.txt

#rm ../Taiwan_Weather_201802.mp4
#ffmpeg -f concat -safe 0 -i join.txt  -c copy ../Taiwan_Weather_201802.mp4

