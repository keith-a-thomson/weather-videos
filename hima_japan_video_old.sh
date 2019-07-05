cd ~/$1
pwd
#date1=`date +'%Y%m%d'`
#date2=`date +'%Y-%m-%d'`
#date_yesterday=`TZ=GMT+24 date +%Y%m%d`

#date1=$1$2$3
#date2=$1-$2-$3


rm -rf /tmp/himajp*

xcount=0; 
for i in ./*;    
do 
	counter=$(printf %05d $xcount); 
	cp "${i}" "/tmp/himajp_${counter}.png"
	xcount=$(($xcount+1)); 
done
cd ..

ffmpeg -f image2 \
		-framerate 24 -i 'C:\cygwin64\tmp\himajp_%05d.png' \
		-filter:v "crop=in_w-1:in_h-1:0:0" \
		-vcodec libx265 \
		-crf 0 -pix_fmt yuv420p -preset slow \
		-r 24 \
		output.mp4

rm -rf /tmp/himajp*

