cd ${HOME}/${5}_meso_0${4}_ir
pwd

enable_vid=true
enable_join=false
time_diff=60
time_tol=5
if [ "$5" = "hima" ]
then
	time_diff=150
fi

date=$1$2$3
date_=$1-$2-$3


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

xcount=0;
prevcounter=$(printf %06d $xcount);

previous_i=$dir_yesterday;
previous_t=${yesterday_t};
previous_d=${date_yesterday};

# Work out the exact previous folder
for old in ${previous_d}/*;
do
	if [ -d $old ];
	then
		last_one=$old
	fi
done
if [ ! "${last_one}" = "" ];
then
	# Last 14 is the date
	current=${last_one:(-14)}
	current_t=$(date -d "${current:0:8} ${current:8:2}:${current:10:2}:${current:12:2}" +'%s')
	previous_t=${current_t}
	previous_i=${current}
fi

tmpname=ir_${5}_meso_0${4}_ir
mkdir -p /tmp/${tmpname}
rm -rf /tmp/${tmpname}/*
if [ -d ${previous_d}/${previous_i} ];
then
	mkdir -p /tmp/${tmpname}/${previous_d}/${previous_i}
	cp -r ${previous_d}/${previous_i}/* /tmp/${tmpname}/${previous_d}/${previous_i}
fi
cp -r ${date_} /tmp/${tmpname}/

cd /tmp/${tmpname}/${date_}
for i in ./*;
do 
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
			missing=0
			for testmiss in {2..10}; do
				diffmult=$((time_diff*testmiss))
				if (( (diff2 > diffmult-time_tol) && (diff2 < diffmult+time_tol) ));
				then
					missing=$((testmiss-1))
					break
				fi
			done
			
			if (( missing > 0 ));
			then
				prevcounter=${counter}
				for ((newidx=1; newidx<=missing; newidx++)); do
					counter=$(printf %06d $xcount);
					for f in $current/*; do
						fname=${f##*/}
						if [ ! "$prevcounter" = "" ];
						then
							magick `interpolate.sh $missing $newidx ../${tmpname}_${prevcounter}_${fname} $f` -evaluate-sequence mean ../${tmpname}_${counter}_${fname}
						else
							magick `interpolate.sh $missing $newidx ../${previous_d}/${previous_i}/${fname} $f` -evaluate-sequence mean ../${tmpname}_${counter}_${fname}
						fi
						
					done
					xcount=$(($xcount+1));
				done
			else
				echo "Unexpected missing difference - $diff2"
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
		mv $f ../${tmpname}_${counter}_${fname}
	done

	xcount=$(($xcount+1)); 
done

echo "frame_count=${xcount}"
if [ "$enable_vid" = true ]
then
	cd ${HOME}/${5}_meso_0${4}_ir
	ffmpeg -f image2 \
	        -framerate 24 -i 'C:\cygwin64\tmp\'${tmpname}'\'${tmpname}'_%06d_000_000.png' \
	        -r 24 \
		-vcodec libx265 \
		-crf 0 -pix_fmt yuv420p -preset ultrafast \
		${date}_${5}_meso_0${4}_ir.mp4
fi
rm -rf /tmp/${tmpname}/*

if [ "$enable_join" = true ]
then
	echo "file '${date}_${5}_meso_0${4}_ir.mp4'" >> join.txt
fi

