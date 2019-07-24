cd ${HOME}/hima_meso/
pwd

enable_vid=true
enable_join=true

date=$1$2$3
date_=$1-$2-$3
cd ${date_}

midnight=`date -d ${date_} +"%s"`
yesterday_t=$((midnight-600))
date_yesterday=`date -d @${yesterday_t} +'%Y-%m-%d'`
dir_yesterday=`date -d @${yesterday_t} +'%Y%m%d%H%M%S'`
if [ ! -d ../${date_yesterday}/${dir_yesterday} ];
then
        yesterday_t=$((midnight-1200))
        date_yesterday=`date -d @${yesterday_t} +'%Y-%m-%d'`
        dir_yesterday=`date -d @${yesterday_t} +'%Y%m%d%H%M%S'`
fi

rm -rf /tmp/himameso*

xcount=0;
previous_i=$dir_yesterday;
previous_t=${yesterday_t};
previous_d=${date_yesterday};

for i in ./*;    
do 
#	echo "i=$i"

	current=${i:2}
	current_t=$(date -d "${current:0:8} ${current:8:2}:${current:10:2}:${current:12:2}" +'%s')
	diff2=$(((current_t)-(previous_t)))

#	if [ ! $diff2 -eq 150 ];
#	then
#		if [ -d ../${previous_d} ];
#		then
#			echo "Found missing - $diff $diff2 ${previous_i} $current"
#                        if [ $diff2 -eq 1200 ];
#                        then
#                                # missing one frame
#                                counter=$(printf %06d $xcount);
#                                for f in $current/*;
#                                do
#                                        fname=${f##*/}
#                                        magick $f ../${previous_d}/${previous_i}/${fname} -evaluate-sequence mean 'C:\cygwin64\tmp\'himameso_${counter}_${fname}
#                                done
#                                xcount=$(($xcount+1));
#                        fi
#		fi
#	fi
	previous_i=$current
	previous_t=${current_t}
	previous_d=${date_}

	# Regular copy
	counter=$(printf %06d $xcount); 
	for f in $i/*;
	do
		fname=${f##*/}
		cp $f /tmp/himameso_${counter}_${fname}
	done

	xcount=$(($xcount+1)); 
done
cd ..
echo "frame_count=${xcount}"
if [ "$enable_vid" = true ]
then
	ffmpeg -f image2 \
	        -framerate 24 -i 'C:\cygwin64\tmp\himameso_%06d_000_000.png' \
	        -framerate 24 -i 'C:\cygwin64\tmp\himameso_%06d_001_000.png' \
	        -framerate 24 -i 'C:\cygwin64\tmp\himameso_%06d_000_001.png' \
	        -framerate 24 -i 'C:\cygwin64\tmp\himameso_%06d_001_001.png' \
	        -filter_complex "[0:v][1:v]vstack=inputs=2[row1];\
	                         [2:v][3:v]vstack=inputs=2[row2];\
	                         [row1][row2]hstack=inputs=2[v]" \
		-shortest \
	        -map "[v]" \
	        -r 24 \
                -vcodec libx265 \
                -crf 0 -pix_fmt yuv420p -preset slow \
		${date}_himawari_mesoscale_raw.mp4
fi
rm -rf /tmp/himameso*

#if [ "$enable_join" = true ]
#then
#	echo "file '${date}_himawari.mp4'" >> join.txt
#	rm ../Himawari_Full_201712.mp4
#	ffmpeg -f concat -safe 0 -i join.txt  -c copy ../Himawari_Full_201712.mp4
#fi

