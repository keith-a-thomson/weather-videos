timefunc() {
	printf "$1" |\
		convert -size 800x80 -pointsize 16 -fill white -undercolor '#00000080' -gravity NorthWest -annotate +0+0 @- xc:none ../${tmpname}_${counter}_time.png
}

cd ${HOME}/hima_meso_01/
pwd

enable_copy=true
enable_vid=true
enable_join=false
time_diff=150
time_tol=5

date=$1$2$3
date_=$1-$2-$3

midnight=`date -d ${date_} +"%s"`
yesterday_t=$((midnight-600))
date_yesterday=`date -d @${yesterday_t} +'%Y-%m-%d'`
date_yesterday_space=`date -d @${yesterday_t} +'%Y %m %d'`
tmpname=hima_x_meso_01
if [ "$enable_copy" = true ]
then
	rm -rf /tmp/${tmpname}*
	mkdir -p /tmp/${tmpname}_video

	xcount=0;
	bcount=0;
	first=true

        echo Checkstart
        start=`hima_meso_vidstart.sh ${date_yesterday_space}`
        if [ "$start" = "" ]
        then
                start=${date}000000
        fi
        echo Start at ${start}
        start_t=$(date -d "${start:0:8} ${start:8:2}:${start:10:2}:${start:12:2}" +'%s')


	for i in ${date_yesterday}/* ${date_}/*;	
	do 
	#	echo "i=$i"

		current=${i:11}
		current_t=$(date -d "${current:0:8} ${current:8:2}:${current:10:2}:${current:12:2}" +'%s')
		
		# Skip to the start of the day
		if ((current_t < start_t));
		then
			continue
		fi

		# Sanity check the directory
		files=`ls -1 ${i}/ | wc -l`
		if [ ! "$files" -eq "12" ];
		then
			continue
		fi

		if (( xcount > 200 ));
		then
			# Stop if we hit blackness after min 200 frames
			b1=`identify -format "%[mean]" ${i}/000_000_1.png`
			b2=`identify -format "%[mean]" ${i}/001_000_1.png`
			b3=`identify -format "%[mean]" ${i}/000_001_1.png`
			b4=`identify -format "%[mean]" ${i}/001_001_1.png`
			wait
			btotal=$(awk "BEGIN {printf(\"%.0f\n\", ${b1} + ${b2} + ${b3} + ${b4}); exit}")
			if (( btotal < 200 ));
			then
				bcount=$(($bcount+1))
			fi
			if (( bcount > 30 ));
			then
				echo ${current} - 30 blacks detected - break
				break
			fi		
		fi
		
		rm -rf /tmp/${tmpname}_video/*	
		cp ${i}/*.png /tmp/${tmpname}_video/
		
		cd /tmp/${tmpname}_video
		# Generate output 
		for x in {000..001..1};
		do
			for y in {000..001..1};
			do
				this=${x}_${y}
				magick convert ${this}_3.png ${this}_2.png ${this}_1.png -combine PNG24:${this}.png &
			done
		done
		wait
		rm *_1.png &
		rm *_2.png &
		rm *_3.png &
		wait
		
		diff2=$(((current_t)-(previous_t)))
		if (( diff2 > time_diff+time_tol  && xcount > 0 ));
		then
			echo "Found missing $diff2 - $current"
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
					for f in ./*; do
						fname=${f##*/}
						magick `interpolate.sh $missing $newidx ../${tmpname}_${prevcounter}_${fname} $f` -evaluate-sequence mean ../${tmpname}_${counter}_${fname} &
					done
					timefunc " ${current:0:4}-${current:4:2}-${current:6:2} ${current:8:2}:${current:10:2} UTC (Interpolate)\nHimawari Mesoscale"
					xcount=$(($xcount+1));
					wait
				done
			else
				echo "Unexpected missing difference - $diff2"
			fi
		fi

		# Output files into place
		counter=$(printf %06d $xcount); 
		mv 000_000.png ../${tmpname}_${counter}_000_000.png &
		mv 000_001.png ../${tmpname}_${counter}_000_001.png &
		mv 001_000.png ../${tmpname}_${counter}_001_000.png &
		mv 001_001.png ../${tmpname}_${counter}_001_001.png &
		timefunc " ${current:0:4}-${current:4:2}-${current:6:2} ${current:8:2}:${current:10:2} UTC\nHimawari Mesoscale"
		wait
		cd - > /dev/null
		
		previous_i=$current
		previous_t=${current_t}
		xcount=$(($xcount+1)); 
	done
	echo "frame_count=${xcount}"
fi

if [ "$enable_vid" = true ]
then
	#
	ffmpeg -hide_banner -f image2 \
		-framerate 24 -i 'C:\cygwin64\tmp\'${tmpname}'_%06d_000_000.png' \
		-framerate 24 -i 'C:\cygwin64\tmp\'${tmpname}'_%06d_001_000.png' \
		-framerate 24 -i 'C:\cygwin64\tmp\'${tmpname}'_%06d_000_001.png' \
		-framerate 24 -i 'C:\cygwin64\tmp\'${tmpname}'_%06d_001_001.png' \
		-framerate 24 -i 'C:\cygwin64\tmp\'${tmpname}'_%06d_time.png' \
		-filter_complex "[0:v][1:v]vstack=inputs=2[row1];\
						 [2:v][3:v]vstack=inputs=2[row2];\
						 [row1][row2]hstack=inputs=2[v2];\
						 [v2]pad=0:1080[v3];\
						 [v3][4:v]overlay=y=1000[v]" \
		-shortest \
		-map "[v]" \
		-r 24 \
		-vcodec libx265 \
		-crf 0 -pix_fmt yuv420p -preset ultrafast \
		${date}_hima_mesoscale01.mp4
fi
rm -rf /tmp/${tmpname}*

if [ "$enable_join" = true ]
then
	echo "file '${date_}/${date}_hima_mesoscale01.mp4'" >> ${date_}/join.txt
fi

