cd ${HOME}/uk_rain
pwd

enable_vid=true
enable_join=false

date=$1$2$3
date_=$1-$2-$3

cd ${date_}
rm -rf /tmp/ukrain*

for i in ./*;    
do 
#	echo "i=$i"

	# Regular copy
	counter=$(printf %06d $xcount); 

#	magick.exe convert -size 800x200 -pointsize 72 -fill white -undercolor '#00000080' -gravity Center -annotate +0+0 ' '${date_}' '${i}' ' xc:none ukrain_${counter}_time.png
	printf " ${date_} ${i:2:2}:${i:4:2}" | convert -size 800x600 -pointsize 72 -fill white -undercolor '#00000080' -gravity Center -annotate +0+0 @- xc:none ukrain_${counter}_time.png
	mv ukrain_${counter}_time.png /tmp

	for f in $i/*;
	do
		fname=${f##*/}
		cp $f /tmp/ukrain_${counter}_${fname}
	done

	xcount=$(($xcount+1)); 
done
cd ..
echo "frame_count=${xcount}"
if [ "$enable_vid" = true ]
then
	ffmpeg -f image2 \
				-framerate 24 -i 'C:\cygwin64\tmp\ukrain_%06d_37_59.png' \
				-framerate 24 -i 'C:\cygwin64\tmp\ukrain_%06d_38_59.png' \
				-framerate 24 -i 'C:\cygwin64\tmp\ukrain_%06d_39_59.png' \
				-framerate 24 -i 'C:\cygwin64\tmp\ukrain_%06d_40_59.png' \
				-framerate 24 -i 'C:\cygwin64\tmp\ukrain_%06d_41_59.png' \
				-framerate 24 -i 'C:\cygwin64\tmp\ukrain_%06d_42_59.png' \
				-framerate 24 -i 'C:\cygwin64\tmp\ukrain_%06d_43_59.png' \
				-framerate 24 -i 'C:\cygwin64\tmp\ukrain_%06d_44_59.png' \
				-framerate 24 -i 'C:\cygwin64\tmp\ukrain_%06d_37_60.png' \
				-framerate 24 -i 'C:\cygwin64\tmp\ukrain_%06d_38_60.png' \
				-framerate 24 -i 'C:\cygwin64\tmp\ukrain_%06d_39_60.png' \
				-framerate 24 -i 'C:\cygwin64\tmp\ukrain_%06d_40_60.png' \
				-framerate 24 -i 'C:\cygwin64\tmp\ukrain_%06d_41_60.png' \
				-framerate 24 -i 'C:\cygwin64\tmp\ukrain_%06d_42_60.png' \
				-framerate 24 -i 'C:\cygwin64\tmp\ukrain_%06d_43_60.png' \
				-framerate 24 -i 'C:\cygwin64\tmp\ukrain_%06d_44_60.png' \
				-framerate 24 -i 'C:\cygwin64\tmp\ukrain_%06d_37_61.png' \
				-framerate 24 -i 'C:\cygwin64\tmp\ukrain_%06d_38_61.png' \
				-framerate 24 -i 'C:\cygwin64\tmp\ukrain_%06d_39_61.png' \
				-framerate 24 -i 'C:\cygwin64\tmp\ukrain_%06d_40_61.png' \
				-framerate 24 -i 'C:\cygwin64\tmp\ukrain_%06d_41_61.png' \
				-framerate 24 -i 'C:\cygwin64\tmp\ukrain_%06d_42_61.png' \
				-framerate 24 -i 'C:\cygwin64\tmp\ukrain_%06d_43_61.png' \
				-framerate 24 -i 'C:\cygwin64\tmp\ukrain_%06d_44_61.png' \
				-framerate 24 -i 'C:\cygwin64\tmp\ukrain_%06d_37_62.png' \
				-framerate 24 -i 'C:\cygwin64\tmp\ukrain_%06d_38_62.png' \
				-framerate 24 -i 'C:\cygwin64\tmp\ukrain_%06d_39_62.png' \
				-framerate 24 -i 'C:\cygwin64\tmp\ukrain_%06d_40_62.png' \
				-framerate 24 -i 'C:\cygwin64\tmp\ukrain_%06d_41_62.png' \
				-framerate 24 -i 'C:\cygwin64\tmp\ukrain_%06d_42_62.png' \
				-framerate 24 -i 'C:\cygwin64\tmp\ukrain_%06d_43_62.png' \
				-framerate 24 -i 'C:\cygwin64\tmp\ukrain_%06d_44_62.png' \
				-framerate 24 -i 'C:\cygwin64\tmp\ukrain_%06d_37_63.png' \
				-framerate 24 -i 'C:\cygwin64\tmp\ukrain_%06d_38_63.png' \
				-framerate 24 -i 'C:\cygwin64\tmp\ukrain_%06d_39_63.png' \
				-framerate 24 -i 'C:\cygwin64\tmp\ukrain_%06d_40_63.png' \
				-framerate 24 -i 'C:\cygwin64\tmp\ukrain_%06d_41_63.png' \
				-framerate 24 -i 'C:\cygwin64\tmp\ukrain_%06d_42_63.png' \
				-framerate 24 -i 'C:\cygwin64\tmp\ukrain_%06d_43_63.png' \
				-framerate 24 -i 'C:\cygwin64\tmp\ukrain_%06d_44_63.png' \
				-framerate 24 -i 'C:\cygwin64\tmp\ukrain_%06d_37_64.png' \
				-framerate 24 -i 'C:\cygwin64\tmp\ukrain_%06d_38_64.png' \
				-framerate 24 -i 'C:\cygwin64\tmp\ukrain_%06d_39_64.png' \
				-framerate 24 -i 'C:\cygwin64\tmp\ukrain_%06d_40_64.png' \
				-framerate 24 -i 'C:\cygwin64\tmp\ukrain_%06d_41_64.png' \
				-framerate 24 -i 'C:\cygwin64\tmp\ukrain_%06d_42_64.png' \
				-framerate 24 -i 'C:\cygwin64\tmp\ukrain_%06d_43_64.png' \
				-framerate 24 -i 'C:\cygwin64\tmp\ukrain_%06d_44_64.png' \
				-framerate 24 -i 'C:\cygwin64\tmp\ukrain_%06d_37_65.png' \
				-framerate 24 -i 'C:\cygwin64\tmp\ukrain_%06d_38_65.png' \
				-framerate 24 -i 'C:\cygwin64\tmp\ukrain_%06d_39_65.png' \
				-framerate 24 -i 'C:\cygwin64\tmp\ukrain_%06d_40_65.png' \
				-framerate 24 -i 'C:\cygwin64\tmp\ukrain_%06d_41_65.png' \
				-framerate 24 -i 'C:\cygwin64\tmp\ukrain_%06d_42_65.png' \
				-framerate 24 -i 'C:\cygwin64\tmp\ukrain_%06d_43_65.png' \
				-framerate 24 -i 'C:\cygwin64\tmp\ukrain_%06d_44_65.png' \
				-framerate 24 -i 'C:\cygwin64\tmp\ukrain_%06d_37_66.png' \
				-framerate 24 -i 'C:\cygwin64\tmp\ukrain_%06d_38_66.png' \
				-framerate 24 -i 'C:\cygwin64\tmp\ukrain_%06d_39_66.png' \
				-framerate 24 -i 'C:\cygwin64\tmp\ukrain_%06d_40_66.png' \
				-framerate 24 -i 'C:\cygwin64\tmp\ukrain_%06d_41_66.png' \
				-framerate 24 -i 'C:\cygwin64\tmp\ukrain_%06d_42_66.png' \
				-framerate 24 -i 'C:\cygwin64\tmp\ukrain_%06d_43_66.png' \
				-framerate 24 -i 'C:\cygwin64\tmp\ukrain_%06d_44_66.png' \
				-i 'C:\cygwin64\home\Keith\uk_rain\osm_geofab.png' \
				-framerate 24 -i 'C:\cygwin64\tmp\ukrain_%06d_time.png' \
				-i 'C:\cygwin64\home\Keith\uk_rain\outline.png' \
				-filter_complex "[0:v][1:v][2:v][3:v][4:v][5:v][6:v][7:v]vstack=inputs=8[col1];\
								[8:v][9:v][10:v][11:v][12:v][13:v][14:v][15:v]vstack=inputs=8[col2];\
								[16:v][17:v][18:v][19:v][20:v][21:v][22:v][23:v]vstack=inputs=8[col3];\
								[24:v][25:v][26:v][27:v][28:v][29:v][30:v][31:v]vstack=inputs=8[col4];\
								[32:v][33:v][34:v][35:v][36:v][37:v][38:v][39:v]vstack=inputs=8[col5];\
								[40:v][41:v][42:v][43:v][44:v][45:v][46:v][47:v]vstack=inputs=8[col6];\
								[48:v][49:v][50:v][51:v][52:v][53:v][54:v][55:v]vstack=inputs=8[col7];\
								[56:v][57:v][58:v][59:v][60:v][61:v][62:v][63:v]vstack=inputs=8[col8];\
								[col1][col2][col3][col4][col5][col6][col7][col8]hstack=inputs=8[full];
								[64:v][full]overlay[main];[main][65:v]overlay[q];[q][66:v]overlay[r];\
								[r]crop=in_w:in_h-200[v]" \
				-map "[v]" -shortest \
				-vcodec libx264 \
				-crf 20 -pix_fmt yuv420p -preset fast \
				-r 24 \
	        ${date}_uk_rain.mp4
fi

rm -rf /tmp/ukrain*

#if [ "$enable_join" = true ]
#then
#	echo "file '${date}_goes_conus.mp4'" >> join.txt
#	rm ../Goes_Conus_201801.mp4
#	ffmpeg -f concat -safe 0 -i join.txt  -c copy ../Goes_Conus_201801.mp4
#fi

upload.sh ukr $1 $2 $3
