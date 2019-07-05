cd ${HOME}/${5}_meso_0${4}_ir
pwd

enable_vid=false
enable_join=false
time_diff=60
time_tol=5
if [ "$5" = "hima" ]
then
	time_diff=150
fi

date=$1$2$3
date_=$1-$2-$3
cd ${date_}

midnight=`date -d ${date_} +"%s"`
yesterday_t=$((midnight-900))
date_yesterday=`date -d @${yesterday_t} +'%Y-%m-%d'`
dir_yesterday=`date -d @${yesterday_t} +'%Y%m%d%H%M%S'`
if [ ! -d ../${date_yesterday}/${dir_yesterday} ];
then
        yesterday_t=$((midnight-1200))
        date_yesterday=`date -d @${yesterday_t} +'%Y-%m-%d'`
        dir_yesterday=`date -d @${yesterday_t} +'%Y%m%d%H%M%S'`
fi

tmpname=ir_${5}_meso_0${4}_ir
rm -rf /tmp/${tmpname}*

xcount=0;
previous_i=$dir_yesterday;
previous_t=${yesterday_t};
previous_d=${date_yesterday};

# Work out the exact previous folder
for old in ../${previous_d}/*;
do
	if [ -d $old ];
	then
		last_one=$old
	fi
done
if [ ! "${last_one}" = "" ];
then
	current=${last_one:(-14)}
	current_t=$(date -d "${current:0:8} ${current:8:2}:${current:10:2}:${current:12:2}" +'%s')
	previous_t=${current_t}
	previous_i=${current}
fi


for i in ./*;
do 
#	echo "i=$i"

	# Sanity check the directory
	files=`ls -1 ${i}/ | wc -l`
	if [ ! "$files" -eq "1" ];
	then
		continue
	fi
	
	current=${i:2}
	current_t=$(date -d "${current:0:8} ${current:8:2}:${current:10:2}:${current:12:2}" +'%s')
	diff2=$(((current_t)-(previous_t)))
	
	if (( diff2 > time_diff+time_tol));
	then
		if [ -d ../${previous_d}/${previous_i} ];
		then
			echo "Found missing - $diff $diff2 ${previous_i} $current"
			if (( (diff2 > (time_diff*2)-time_tol) && (diff2 < (time_diff*2)+time_tol) ));
			then
				counter=$(printf %06d $xcount);
				for f in $current/*;
				do
					fname=${f##*/}
					magick ../${previous_d}/${previous_i}/${fname} $f -evaluate-sequence mean 'C:\cygwin64\tmp\'${tmpname}_${counter}_${fname}
				done
				xcount=$(($xcount+1));
			fi

			if (( (diff2 > (time_diff*3)-time_tol) && (diff2 < (time_diff*3)+time_tol) ));
			then
				counter=$(printf %06d $xcount);
				for f in $current/*;
				do
					fname=${f##*/}
					magick ../${previous_d}/${previous_i}/${fname} ../${previous_d}/${previous_i}/${fname} $f -evaluate-sequence mean 'C:\cygwin64\tmp\'${tmpname}_${counter}_${fname}
				done
				xcount=$(($xcount+1));
				
				counter=$(printf %06d $xcount);
				for f in $current/*;
				do
					fname=${f##*/}
					magick ../${previous_d}/${previous_i}/${fname} $f $f -evaluate-sequence mean 'C:\cygwin64\tmp\'${tmpname}_${counter}_${fname}
				done
				xcount=$(($xcount+1));
			fi

			if (( (diff2 > (time_diff*4)-time_tol) && (diff2 < (time_diff*4)+time_tol) ));
			then
				counter=$(printf %06d $xcount);
				for f in $current/*;
				do
					fname=${f##*/}
					magick ../${previous_d}/${previous_i}/${fname} ../${previous_d}/${previous_i}/${fname} ../${previous_d}/${previous_i}/${fname} $f -evaluate-sequence mean 'C:\cygwin64\tmp\'${tmpname}_${counter}_${fname}
				done
				xcount=$(($xcount+1));
				
				counter=$(printf %06d $xcount);
				for f in $current/*;
				do
						fname=${f##*/}
						magick ../${previous_d}/${previous_i}/${fname} ../${previous_d}/${previous_i}/${fname} $f $f -evaluate-sequence mean 'C:\cygwin64\tmp\'${tmpname}_${counter}_${fname}
				done
				xcount=$(($xcount+1));
				
				counter=$(printf %06d $xcount);
				for f in $current/*;
				do
						fname=${f##*/}
						magick ../${previous_d}/${previous_i}/${fname} $f $f $f -evaluate-sequence mean 'C:\cygwin64\tmp\'${tmpname}_${counter}_${fname}
				done
				xcount=$(($xcount+1));
			fi
		fi
	fi
	previous_i=$current
	previous_t=${current_t}
	previous_d=${date_}

	# Regular copy
	counter=$(printf %06d $xcount); 
	for f in $i/*;
	do
		fname=${f##*/}
		cp $f /tmp/${tmpname}_${counter}_${fname}
	done

	xcount=$(($xcount+1)); 
done
cd ..
echo "frame_count=${xcount}"
if [ "$enable_vid" = true ]
then
	ffmpeg -f image2 \
	        -framerate 24 -i 'C:\cygwin64\tmp\'${tmpname}'_%06d_000_000.png' \
	        -r 24 \
		-vcodec libx265 \
		-crf 0 -pix_fmt yuv420p -preset slow \
		${date}_${5}_meso_0${4}_ir.mp4
fi
rm -rf /tmp/${tmpname}*

if [ "$enable_join" = true ]
then
	echo "file '${date}_${5}_meso_0${4}_ir.mp4'" >> join.txt
#	rm ../goesfull_Full_201712.mp4
#	ffmpeg -f concat -safe 0 -i join.txt  -c copy ../goesfull_Full_201712.mp4
fi

