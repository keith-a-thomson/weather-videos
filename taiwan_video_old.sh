cd ~/taiwan_cwb/

#date1=`date +'%Y%m%d'`
#date2=`date +'%Y-%m-%d'`
#date_yesterday=`TZ=GMT+24 date +%Y%m%d`

date1=$1$2$3
date2=$1-$2-$3

rm -rf /tmp/tcwbradar*
rm -rf /tmp/tcwbprecip*
rm -rf /tmp/tcwbtemperature*
rm -rf /tmp/tcwbhimawari*

x=0; for i in radar/${date2}/*.png;       do counter=$(printf %04d $x); cp "$i" /tmp/tcwbradar_"$counter".png;       x=$(($x+1)); done
x=0; for i in precip1/${date2}/*.jpg;     do counter=$(printf %04d $x); cp "$i" /tmp/tcwbprecip1_"$counter".jpg;     x=$(($x+1)); done
x=0; for i in precip2/${date2}/*.jpg;     do counter=$(printf %04d $x); cp "$i" /tmp/tcwbprecip2_"$counter".jpg;     x=$(($x+1)); done
x=0; for i in temperature/${date2}/*.jpg; do counter=$(printf %04d $x); cp "$i" /tmp/tcwbtemperature_"$counter".jpg; x=$(($x+1)); done
x=0; for i in himawari/${date2}/*.png;    do counter=$(printf %04d $x); cp "$i" /tmp/tcwbhimawari_"$counter".png;    x=$(($x+1)); done

ffmpeg -f image2 \
	-framerate 24 -i 'C:\cygwin64\tmp\tcwbradar_%04d.png' \
	-framerate 8 -i 'C:\cygwin64\tmp\tcwbprecip1_%04d.jpg' \
	-framerate 8 -i 'C:\cygwin64\tmp\tcwbprecip2_%04d.jpg' \
	-framerate 4 -i 'C:\cygwin64\tmp\tcwbtemperature_%04d.jpg' \
	-framerate 24 -i 'C:\cygwin64\tmp\tcwbhimawari_%04d.png' \
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

rm -rf /tmp/tcwbradar*
rm -rf /tmp/tcwbprecip*
rm -rf /tmp/tcwbtemperature*
rm -rf /tmp/tcwbhimawari*

#echo "file '${date1}_radar.mp4'" >> join.txt

#rm ../Taiwan_Weather_201802.mp4
#ffmpeg -f concat -safe 0 -i join.txt  -c copy ../Taiwan_Weather_201802.mp4

