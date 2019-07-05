timefunc() {
	printf "$1" |\
		convert -size 800x200 -pointsize 32 -fill white -undercolor '#00000080' -gravity NorthWest -annotate +0+0 @- xc:none ../${tmpname}_${counter}_time.png
}

cd ${HOME}/hima_japan/
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
tmpname=hima_japan_vis
if [ "$enable_copy" = true ]
then
	rm -rf /tmp/${tmpname}*
	mkdir -p /tmp/${tmpname}_video

	xcount=0;
	bcount=0;
	first=true

	echo Checkstart	
	start=`hima_japan_meso_vidstart.sh ${date_yesterday_space}`
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
		if [ ! "$files" -eq "48" ];
		then
			continue
		fi
		
		if (( xcount > 200 ));
		then
			# Stop if we hit blackness after min 200 frames - corners
			b1=`identify -format "%[mean]" ${i}/000_001_1.png`
			b2=`identify -format "%[mean]" ${i}/003_000_1.png`
			b3=`identify -format "%[mean]" ${i}/000_003_1.png`
			b4=`identify -format "%[mean]" ${i}/003_002_1.png`
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
		for x in {000..003..1};
		do
			for y in {000..003..1};
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
					timefunc " ${current:0:4}-${current:4:2}-${current:6:2} ${current:8:2}:${current:10:2} UTC (Interpolate)\nHimawari Japan ${4}"
					xcount=$(($xcount+1));
					wait
				done
			else
				echo "Unexpected missing difference - $diff2"
			fi
		fi
		
		# Output files into place
		counter=$(printf %06d $xcount);
		for x in {000..003..1};
		do
			for y in {000..003..1};
			do
				this=${x}_${y}
				mv ${this}.png ../${tmpname}_${counter}_${this}.png &
			done
		done
		timefunc " ${current:0:4}-${current:4:2}-${current:6:2} ${current:8:2}:${current:10:2} UTC\nHimawari Japan ${4}"
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
	ffmpeg -f image2 \
			-framerate 24 -i 'C:\cygwin64\tmp\'${tmpname}'_%06d_000_000.png' \
			-framerate 24 -i 'C:\cygwin64\tmp\'${tmpname}'_%06d_001_000.png' \
			-framerate 24 -i 'C:\cygwin64\tmp\'${tmpname}'_%06d_002_000.png' \
			-framerate 24 -i 'C:\cygwin64\tmp\'${tmpname}'_%06d_003_000.png' \
			-framerate 24 -i 'C:\cygwin64\tmp\'${tmpname}'_%06d_000_001.png' \
			-framerate 24 -i 'C:\cygwin64\tmp\'${tmpname}'_%06d_001_001.png' \
			-framerate 24 -i 'C:\cygwin64\tmp\'${tmpname}'_%06d_002_001.png' \
			-framerate 24 -i 'C:\cygwin64\tmp\'${tmpname}'_%06d_003_001.png' \
			-framerate 24 -i 'C:\cygwin64\tmp\'${tmpname}'_%06d_000_002.png' \
			-framerate 24 -i 'C:\cygwin64\tmp\'${tmpname}'_%06d_001_002.png' \
			-framerate 24 -i 'C:\cygwin64\tmp\'${tmpname}'_%06d_002_002.png' \
			-framerate 24 -i 'C:\cygwin64\tmp\'${tmpname}'_%06d_003_002.png' \
			-framerate 24 -i 'C:\cygwin64\tmp\'${tmpname}'_%06d_000_003.png' \
			-framerate 24 -i 'C:\cygwin64\tmp\'${tmpname}'_%06d_001_003.png' \
			-framerate 24 -i 'C:\cygwin64\tmp\'${tmpname}'_%06d_002_003.png' \
			-framerate 24 -i 'C:\cygwin64\tmp\'${tmpname}'_%06d_003_003.png' \
			-framerate 24 -i 'C:\cygwin64\tmp\'${tmpname}'_%06d_time.png' \
			-filter_complex "[0:v][1:v][2:v][3:v]vstack=inputs=4[row1];\
							[4:v][5:v][6:v][7:v]vstack=inputs=4[row2];\
							[8:v][9:v][10:v][11:v]vstack=inputs=4[row3];\
							[12:v][13:v][14:v][15:v]vstack=inputs=4[row4];\
							[row1][row2][row3][row4]hstack=inputs=4[join];\
							[join]crop=2590:2060:302:480,unsharp[j];\
							[j][16:v]overlay[v]" \
			-shortest \
			-map "[v]" \
			-r 24 \
			-vcodec libx265 \
			-crf 0 -pix_fmt yuv420p -preset ultrafast \
			${date}_himawari_japan.mp4
fi
rm -rf /tmp/${tmpname}*

#if [ "$enable_join" = true ]
#then
#	echo "file '${date}_himawari.mp4'" >> join.txt
#	rm ../Himawari_Full_201712.mp4
#	ffmpeg -f concat -safe 0 -i join.txt  -c copy ../Himawari_Full_201712.mp4
#fi

