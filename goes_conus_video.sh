if [ "$#" -ne 4 ];
then
        echo "Run as goes_conus_video.sh yyyy mm dd 16"
        exit 0
fi


cd ${HOME}/goes_${4}_conus/
pwd

tdir=/tmp/
enable_vid=true
enable_join=false

#date1=`date +'%Y%m%d'`
#date2=`date +'%Y-%m-%d'`
#date_yesterday=`TZ=GMT+24 date +%Y%m%d`

date=$1$2$3
date_=$1-$2-$3

midnight=`date -d ${date_} +"%s"`
yesterday_t=$((midnight-600))
date_yesterday=`date -d @${yesterday_t} +'%Y-%m-%d'`
dir_yesterday=`date -d @${yesterday_t} +'%Y%m%d%H%M%S'`

cd ${date_}
rm -rf /tmp/goes${4}conus*

xcount=0;
previous_i=$dir_yesterday;
previous_t=${yesterday_t};
previous_d=${date_yesterday};

for i in ./*;    
do 
#	echo "i=$i"

	current=${i:2}
	current_t=$(date -d "${current:0:8} ${current:8:4}" +'%s')
	diff2=$(((current_t)-(previous_t)))
        if [ ! $diff2 -eq 300 ];
        then
		if [ -d ../${previous_d}/${previous_i} ];
		then
			echo "Found missing - $diff $diff2 ${previous_i} $current"

			if [ $diff2 -eq 600 ];
			then
				counter=$(printf %06d $xcount);
				for f in $current/*;
				do
					fname=${f##*/}
					convert ../${previous_d}/${previous_i}/${fname} $f -evaluate-sequence mean ${tdir}goes${4}conus_${counter}_${fname}
				done
				xcount=$(($xcount+1));
			fi

			if [ $diff2 -eq 900 ];
			then
                                counter=$(printf %06d $xcount);
                                for f in $current/*;
                                do
                                        fname=${f##*/}
                                        convert ../${previous_d}/${previous_i}/${fname} ../${previous_d}/${previous_i}/${fname} $f -evaluate-sequence mean ${tdir}goes${4}conus_${counter}_${fname}
                                done
                                xcount=$(($xcount+1));

                                counter=$(printf %06d $xcount);
                                for f in $current/*;
                                do
                                        fname=${f##*/}
                                        convert ../${previous_d}/${previous_i}/${fname} $f $f -evaluate-sequence mean ${tdir}goes${4}conus_${counter}_${fname}
                                done
                                xcount=$(($xcount+1));
			fi

                        if [ $diff2 -eq 1200 ];
                        then
                                counter=$(printf %06d $xcount);
                                for f in $current/*;
                                do
                                        fname=${f##*/}
                                        convert ../${previous_d}/${previous_i}/${fname} ../${previous_d}/${previous_i}/${fname}  ../${previous_d}/${previous_i}/${fname} $f -evaluate-sequence mean ${tdir}goes${4}conus_${counter}_${fname}
                                done
                                xcount=$(($xcount+1));

                                counter=$(printf %06d $xcount);
                                for f in $current/*;
                                do
                                        fname=${f##*/}
                                        convert ../${previous_d}/${previous_i}/${fname}  ../${previous_d}/${previous_i}/${fname} $f $f -evaluate-sequence mean ${tdir}goes${4}conus_${counter}_${fname}
                                done
                                xcount=$(($xcount+1));

                                counter=$(printf %06d $xcount);
                                for f in $current/*;
                                do
                                        fname=${f##*/}
                                        convert ../${previous_d}/${previous_i}/${fname} $f $f $f -evaluate-sequence mean ${tdir}goes${4}conus_${counter}_${fname}
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
		cp $f /tmp/goes${4}conus_${counter}_${fname}
	done

	xcount=$(($xcount+1)); 
done
cd ..
echo "frame_count=${xcount}"
if [ "$enable_vid" = true ]
then
	ffmpeg -f image2 \
                -framerate 24 -i ${tdir}'goes'${4}'conus_%06d_001_000.png' \
                -framerate 24 -i ${tdir}'goes'${4}'conus_%06d_002_000.png' \
                -framerate 24 -i ${tdir}'goes'${4}'conus_%06d_003_000.png' \
                -framerate 24 -i ${tdir}'goes'${4}'conus_%06d_004_000.png' \
                -framerate 24 -i ${tdir}'goes'${4}'conus_%06d_005_000.png' \
                -framerate 24 -i ${tdir}'goes'${4}'conus_%06d_006_000.png' \
                -framerate 24 -i ${tdir}'goes'${4}'conus_%06d_001_001.png' \
                -framerate 24 -i ${tdir}'goes'${4}'conus_%06d_002_001.png' \
                -framerate 24 -i ${tdir}'goes'${4}'conus_%06d_003_001.png' \
                -framerate 24 -i ${tdir}'goes'${4}'conus_%06d_004_001.png' \
                -framerate 24 -i ${tdir}'goes'${4}'conus_%06d_005_001.png' \
                -framerate 24 -i ${tdir}'goes'${4}'conus_%06d_006_001.png' \
                -framerate 24 -i ${tdir}'goes'${4}'conus_%06d_001_002.png' \
                -framerate 24 -i ${tdir}'goes'${4}'conus_%06d_002_002.png' \
                -framerate 24 -i ${tdir}'goes'${4}'conus_%06d_003_002.png' \
                -framerate 24 -i ${tdir}'goes'${4}'conus_%06d_004_002.png' \
                -framerate 24 -i ${tdir}'goes'${4}'conus_%06d_005_002.png' \
                -framerate 24 -i ${tdir}'goes'${4}'conus_%06d_006_002.png' \
                -framerate 24 -i ${tdir}'goes'${4}'conus_%06d_001_003.png' \
                -framerate 24 -i ${tdir}'goes'${4}'conus_%06d_002_003.png' \
                -framerate 24 -i ${tdir}'goes'${4}'conus_%06d_003_003.png' \
                -framerate 24 -i ${tdir}'goes'${4}'conus_%06d_004_003.png' \
                -framerate 24 -i ${tdir}'goes'${4}'conus_%06d_005_003.png' \
                -framerate 24 -i ${tdir}'goes'${4}'conus_%06d_006_003.png' \
                -framerate 24 -i ${tdir}'goes'${4}'conus_%06d_001_004.png' \
                -framerate 24 -i ${tdir}'goes'${4}'conus_%06d_002_004.png' \
                -framerate 24 -i ${tdir}'goes'${4}'conus_%06d_003_004.png' \
                -framerate 24 -i ${tdir}'goes'${4}'conus_%06d_004_004.png' \
                -framerate 24 -i ${tdir}'goes'${4}'conus_%06d_005_004.png' \
                -framerate 24 -i ${tdir}'goes'${4}'conus_%06d_006_004.png' \
                -framerate 24 -i ${tdir}'goes'${4}'conus_%06d_001_005.png' \
                -framerate 24 -i ${tdir}'goes'${4}'conus_%06d_002_005.png' \
                -framerate 24 -i ${tdir}'goes'${4}'conus_%06d_003_005.png' \
                -framerate 24 -i ${tdir}'goes'${4}'conus_%06d_004_005.png' \
                -framerate 24 -i ${tdir}'goes'${4}'conus_%06d_005_005.png' \
                -framerate 24 -i ${tdir}'goes'${4}'conus_%06d_006_005.png' \
                -framerate 24 -i ${tdir}'goes'${4}'conus_%06d_001_006.png' \
                -framerate 24 -i ${tdir}'goes'${4}'conus_%06d_002_006.png' \
                -framerate 24 -i ${tdir}'goes'${4}'conus_%06d_003_006.png' \
                -framerate 24 -i ${tdir}'goes'${4}'conus_%06d_004_006.png' \
                -framerate 24 -i ${tdir}'goes'${4}'conus_%06d_005_006.png' \
                -framerate 24 -i ${tdir}'goes'${4}'conus_%06d_006_006.png' \
                -framerate 24 -i ${tdir}'goes'${4}'conus_%06d_001_007.png' \
				-framerate 24 -i ${tdir}'goes'${4}'conus_%06d_002_007.png' \
				-framerate 24 -i ${tdir}'goes'${4}'conus_%06d_003_007.png' \
				-framerate 24 -i ${tdir}'goes'${4}'conus_%06d_004_007.png' \
				-framerate 24 -i ${tdir}'goes'${4}'conus_%06d_005_007.png' \
                -framerate 24 -i ${tdir}'goes'${4}'conus_%06d_006_007.png' \
	        -filter_complex "[0:v][1:v][2:v][3:v][4:v][5:v]vstack=inputs=6[col1];\
	                         [6:v][7:v][8:v][9:v][10:v][11:v]vstack=inputs=6[col2];\
	                         [12:v][13:v][14:v][15:v][16:v][17:v]vstack=inputs=6[col3];\
	                         [18:v][19:v][20:v][21:v][22:v][23:v]vstack=inputs=6[col4];\
	                         [24:v][25:v][26:v][27:v][28:v][29:v]vstack=inputs=6[col5];\
	                         [30:v][31:v][32:v][33:v][34:v][35:v]vstack=inputs=6[col6];\
                             [36:v][37:v][38:v][39:v][40:v][41:v]vstack=inputs=6[col7];\
                             [42:v][43:v][44:v][45:v][46:v][47:v]vstack=inputs=6[col8];\
	                         [col1][col2][col3][col4][col5][col6][col7][col8]hstack=inputs=8[full];\
	                         [full]scale=3840:-1[h];\
	                         [h]crop=3840:2160[v]" \
	        -map "[v]" -shortest \
                -vcodec libx265 \
                -crf 10 -pix_fmt yuv420p -preset ultrafast \
	        -r 24 \
	        ${date}_goes_${4}_conus.mp4
fi

rm -rf /tmp/goes${4}conus*

if [ "$enable_join" = true ]
then
	echo "file '${date}_goes_${4}_conus.mp4'" >> join.txt
#	rm ../Goes_Conus_201801.mp4
#	ffmpeg -f concat -safe 0 -i join.txt  -c copy ../Goes_Conus_201801.mp4
fi

