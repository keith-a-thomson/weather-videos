timefunc() {
	printf "$1" |\
		convert -size 800x80 -pointsize 16 -fill white -undercolor '#00000080' -gravity NorthWest -annotate +0+0 @- xc:none ../${tmpname}_${counter}_time.png
}

if [ "$#" -ne 5 ];
then
        echo "Run as goes_meso_video.sh yyyy mm dd 1/2 16/17"
        exit 0
fi

cd ${HOME}/goes_${5}_meso_0${4}/
pwd

enable_copy=true
enable_vid=true
enable_join=false
time_diff=60
time_tol=5
enable_colour=false

date=$1$2$3
date_=$1-$2-$3

midnight=`date -d "${date} 23:59:00" +"%s"`
tomorrow_t=$((midnight+9600))
date_tomorrow=`date -d @${tomorrow_t} +'%Y%m%d'`
date_tomorrow_=`date -d @${tomorrow_t} +'%Y-%m-%d'`
tmpname=goes_${5}_meso_0${4}
if [ "$enable_copy" = true ]
then
	rm -rf /tmp/${tmpname}*
	mkdir -p /tmp/${tmpname}_video

	xcount=0;
	bcount=0;
	first=true
	start=`goes_meso_vidstart.sh $1 $2 $3 $4 $5`
	echo Start at ${start}
	start_t=$(date -d "${start:0:8} ${start:8:2}:${start:10:2}:${start:12:2}" +'%s')
	for i in ${date_}/* ${date_tomorrow_}/*;	
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
		if [ ! "$files" -eq "4" ];
		then
			if [ ! "$files" -eq "12" ];
			then
				continue
			fi
		fi

		if (( xcount > 500 ));
		then
			# Stop if we hit blackness after min 500 frames
			b1=`identify -format "%[mean]" ${i}/000_000_2.png`
			b2=`identify -format "%[mean]" ${i}/001_000_2.png`
			b3=`identify -format "%[mean]" ${i}/000_001_2.png`
			b4=`identify -format "%[mean]" ${i}/001_001_2.png`
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
				if [ "$enable_colour" = true ];
				then
					# Make green image
					# 1 - 45% blue
					# 2 - 45% red
					# 3 - 10% veggie
					# http://cimss.ssec.wisc.edu/goes/OCLOFactSheetPDFs/ABIQuickGuide_CIMSSRGB_v2.pdf
					magick convert \
						${this}_1.png \
						-write mpr:mainblue \
						+delete \
						${this}_2.png \
						-write mpr:mainred \
						+delete \
						${this}_3.png \
						-write mpr:maingreen \
						+delete \
						-respect-parentheses \
						 \( mpr:mainblue  -level 0,222.222%    +write mpr:45blue   \) \
						 \( mpr:mainred   -level 0,222.222%    +write mpr:45red    \) \
						 \( mpr:maingreen -level 0,1000%       +write mpr:10veg    \) \
						 \( -composite -compose plus mpr:45red mpr:10veg +write mpr:VR       \) \
						 \( -composite -compose plus mpr:VR mpr:45blue +write mpr:green       \) \
						 \( mpr:mainred mpr:green mpr:mainblue -combine +write PNG24:${this}.png \) \
						null: &
				else
					mv ${this}_2.png ${this}.png
				fi
			done
		done
		wait
		rm -rf *_1.png &
		rm -rf *_2.png &
		rm -rf *_3.png &
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
						convert `interpolate.sh $missing $newidx ../${tmpname}_${prevcounter}_${fname} $f` -evaluate-sequence mean -remap $f PNG8:../${tmpname}_${counter}_${fname} &
					done
					timefunc " ${current:0:4}-${current:4:2}-${current:6:2} ${current:8:2}:${current:10:2} UTC (Interpolate)\nGOES-${5} Mesoscale ${4}"
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
		timefunc " ${current:0:4}-${current:4:2}-${current:6:2} ${current:8:2}:${current:10:2} UTC\nGOES-${5} Mesoscale ${4}"
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
		-framerate 60 -i '/tmp/'${tmpname}'_%06d_000_000.png' \
		-framerate 60 -i '/tmp/'${tmpname}'_%06d_001_000.png' \
		-framerate 60 -i '/tmp/'${tmpname}'_%06d_000_001.png' \
		-framerate 60 -i '/tmp/'${tmpname}'_%06d_001_001.png' \
		-framerate 60 -i '/tmp/'${tmpname}'_%06d_time.png' \
		-filter_complex "[0:v][1:v]vstack=inputs=2[row1];\
						 [2:v][3:v]vstack=inputs=2[row2];\
						 [row1][row2]hstack=inputs=2[v2];\
						 [v2]pad=0:1080[v3];\
						 [v3][4:v]overlay=y=1000[v]" \
		-shortest \
		-map "[v]" \
		-r 60 \
		-vcodec libx265 \
		-crf 10 -pix_fmt yuv420p -preset ultrafast \
		${date}_goes_${5}_mesoscale0${4}.mp4
fi
rm -rf /tmp/${tmpname}*

if [ "$enable_join" = true ]
then
	echo "file '${date_}/${date}_goes_${5}_mesoscale0${4}.mp4'" >> ${date_}/join.txt
fi

