cd ${HOME}/hima_taiwan/
pwd

enable_vid=true
enable_join=true

#date1=`date +'%Y%m%d'`
#date2=`date +'%Y-%m-%d'`
#date_yesterday=`TZ=GMT+24 date +%Y%m%d`

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

rm -rf /tmp/himawari*

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

        if [ ! $diff2 -eq 600 ];
        then
		if [ -d ../${previous_d} ];
		then
			echo "Found missing - $diff $diff2 ${previous_i} $current"
			if [ $diff2 -eq 1200 ];
			then
				# missing one frame
				counter=$(printf %06d $xcount);	
				for f in $current/*;
				do
					fname=${f##*/}
					magick $f ../${previous_d}/${previous_i}/${fname} -evaluate-sequence mean 'C:\cygwin64\tmp\'himawari_${counter}_${fname}
				done
				xcount=$(($xcount+1));
			fi

			if [ $diff2 -eq 1800 ];
			then
				# Missing two
                                counter=$(printf %06d $xcount);
                                for f in $current/*;
                                do
                                        fname=${f##*/}
                                        magick ../${previous_d}/${previous_i}/${fname} ../${previous_d}/${previous_i}/${fname} $f -evaluate-sequence mean 'C:\cygwin64\tmp\'himawari_${counter}_${fname}
                                done
				xcount=$(($xcount+1));

                                counter=$(printf %06d $xcount);
                                for f in $current/*;
                                do
                                        fname=${f##*/}
                                        magick ../${previous_d}/${previous_i}/${fname} $f $f -evaluate-sequence mean 'C:\cygwin64\tmp\'himawari_${counter}_${fname}
                                done
				xcount=$(($xcount+1));
			fi

                        if [ $diff2 -eq 2400 ];
                        then
                                # Missing three
                                counter=$(printf %06d $xcount);
                                for f in $current/*;
                                do
                                        fname=${f##*/}
                                        magick ../${previous_d}/${previous_i}/${fname} \
												../${previous_d}/${previous_i}/${fname} \
												../${previous_d}/${previous_i}/${fname} \
												$f  \
												-evaluate-sequence mean 'C:\cygwin64\tmp\'himawari_${counter}_${fname}
                                done
                                xcount=$(($xcount+1));

                                counter=$(printf %06d $xcount);
                                for f in $current/*;
                                do
                                        fname=${f##*/}
                                        magick ../${previous_d}/${previous_i}/${fname} \
												../${previous_d}/${previous_i}/${fname} \
												$f \
												$f \
						-evaluate-sequence mean 'C:\cygwin64\tmp\'himawari_${counter}_${fname}
                                done
                                xcount=$(($xcount+1));

				counter=$(printf %06d $xcount);
                                for f in $current/*;
                                do
                                        fname=${f##*/}
                                        magick ../${previous_d}/${previous_i}/${fname} \
										$f \
										$f \
										$f \
						-evaluate-sequence mean 'C:\cygwin64\tmp\'himawari_${counter}_${fname}
                                done
                                xcount=$(($xcount+1));
                        fi

                        if [ $diff2 -eq 3000 ];
                        then
                                # Missing four
                                counter=$(printf %06d $xcount);
                                for f in $current/*;
                                do
                                        fname=${f##*/}
                                        magick ../${previous_d}/${previous_i}/${fname} \
                                                ../${previous_d}/${previous_i}/${fname} \
                                                ../${previous_d}/${previous_i}/${fname} \
                                                ../${previous_d}/${previous_i}/${fname} \
                                                $f  \
                                                -evaluate-sequence mean 'C:\cygwin64\tmp\'himawari_${counter}_${fname}
                                done
                                xcount=$(($xcount+1));

                                counter=$(printf %06d $xcount);
                                for f in $current/*;
                                do
                                        fname=${f##*/}
                                        magick ../${previous_d}/${previous_i}/${fname} \
                                                ../${previous_d}/${previous_i}/${fname} \
                                                ../${previous_d}/${previous_i}/${fname} \
                                                $f \
												$f \
                                                -evaluate-sequence mean 'C:\cygwin64\tmp\'himawari_${counter}_${fname}
                                done
                                xcount=$(($xcount+1));

                                counter=$(printf %06d $xcount);
                                for f in $current/*;
                                do
                                        fname=${f##*/}
                                        magick ../${previous_d}/${previous_i}/${fname} \
                                                ../${previous_d}/${previous_i}/${fname} \
                                                $f \
												$f \
												$f \
                                                -evaluate-sequence mean 'C:\cygwin64\tmp\'himawari_${counter}_${fname}
                                done
                                xcount=$(($xcount+1));

                                counter=$(printf %06d $xcount);
                                for f in $current/*;
                                do
                                        fname=${f##*/}
                                        magick ../${previous_d}/${previous_i}/${fname} \
                                                $f \
												$f \
												$f \
												$f \
                                                -evaluate-sequence mean 'C:\cygwin64\tmp\'himawari_${counter}_${fname}
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
		cp $f /tmp/himawari_${counter}_${fname}
	done

	xcount=$(($xcount+1)); 
done
cd ..
echo "frame_count=${xcount}"
if [ "$enable_vid" = true ]
then
	ffmpeg -f image2 \
	        -framerate 24 -i 'C:\cygwin64\tmp\himawari_%06d_002_003.png' \
	        -framerate 24 -i 'C:\cygwin64\tmp\himawari_%06d_003_003.png' \
	        -framerate 24 -i 'C:\cygwin64\tmp\himawari_%06d_004_003.png' \
	        -framerate 24 -i 'C:\cygwin64\tmp\himawari_%06d_005_003.png' \
	        -framerate 24 -i 'C:\cygwin64\tmp\himawari_%06d_002_004.png' \
	        -framerate 24 -i 'C:\cygwin64\tmp\himawari_%06d_003_004.png' \
	        -framerate 24 -i 'C:\cygwin64\tmp\himawari_%06d_004_004.png' \
	        -framerate 24 -i 'C:\cygwin64\tmp\himawari_%06d_005_004.png' \
	        -framerate 24 -i 'C:\cygwin64\tmp\himawari_%06d_002_005.png' \
	        -framerate 24 -i 'C:\cygwin64\tmp\himawari_%06d_003_005.png' \
	        -framerate 24 -i 'C:\cygwin64\tmp\himawari_%06d_004_005.png' \
	        -framerate 24 -i 'C:\cygwin64\tmp\himawari_%06d_005_005.png' \
	        -framerate 24 -i 'C:\cygwin64\tmp\himawari_%06d_002_006.png' \
	        -framerate 24 -i 'C:\cygwin64\tmp\himawari_%06d_003_006.png' \
        	-framerate 24 -i 'C:\cygwin64\tmp\himawari_%06d_004_006.png' \
	        -framerate 24 -i 'C:\cygwin64\tmp\himawari_%06d_005_006.png' \
	        -framerate 24 -i 'C:\cygwin64\tmp\himawari_%06d_002_007.png' \
	        -framerate 24 -i 'C:\cygwin64\tmp\himawari_%06d_003_007.png' \
	        -framerate 24 -i 'C:\cygwin64\tmp\himawari_%06d_004_007.png' \
	        -framerate 24 -i 'C:\cygwin64\tmp\himawari_%06d_005_007.png' \
	        -framerate 24 -i 'C:\cygwin64\tmp\himawari_%06d_002_008.png' \
	        -framerate 24 -i 'C:\cygwin64\tmp\himawari_%06d_003_008.png' \
	        -framerate 24 -i 'C:\cygwin64\tmp\himawari_%06d_004_008.png' \
	        -framerate 24 -i 'C:\cygwin64\tmp\himawari_%06d_005_008.png' \
	        -filter_complex "[0:v][1:v][2:v][3:v]vstack=inputs=4[col1];\
	                         [4:v][5:v][6:v][7:v]vstack=inputs=4[col2];\
	                         [8:v][9:v][10:v][11:v]vstack=inputs=4[col3];\
	                         [12:v][13:v][14:v][15:v]vstack=inputs=4[col4];\
	                         [16:v][17:v][18:v][19:v]vstack=inputs=4[col5];\
	                         [20:v][21:v][22:v][23:v]vstack=inputs=4[col6];\
	                         [col1][col2][col3][col4][col5][col6]hstack=inputs=6[full];\
	                         [full]scale=3840:-1[h];\
	                         [h]crop=3840:2160[v]" \
                -shortest \
                -map "[v]" \
                -r 24 \
                -vcodec libx265 \
                -crf 10 -pix_fmt yuv420p -preset ultrafast \
	        ${date}_himawari_taiwan.mp4
fi

rm -rf /tmp/himawari*

if [ "$enable_join" = true ]
then
	echo "file '${date}_himawari_taiwan.mp4'" >> join.txt
#	rm ../Himawari_Taiwan_201712.mp4
#	ffmpeg -f concat -safe 0 -i join.txt  -c copy ../Himawari_Taiwan_201712.mp4
fi

