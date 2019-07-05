cd ~/hima_taiwan/
pwd
#date1=`date +'%Y%m%d'`
#date2=`date +'%Y-%m-%d'`
#date_yesterday=`TZ=GMT+24 date +%Y%m%d`

date1=$1$2$3
date2=$1-$2-$3

cd ${date2}
rm -rf /tmp/himawari*

xcount=0; 
for i in ./*;    
do 
	echo $i
	counter=$(printf %04d $xcount); 

        for x in {002..005..1}
        do
	        for y in {003..008..1}
                do
			cp "${i}/${x}_${y}.png" "/tmp/himawari_${x}_${y}_${counter}.png"    
		done
	done

	xcount=$(($xcount+1)); 
done
cd ..

ffmpeg -f image2 \
        -framerate 24 -i 'C:\cygwin64\tmp\himawari_002_003_%04d.png' \
        -framerate 24 -i 'C:\cygwin64\tmp\himawari_003_003_%04d.png' \
        -framerate 24 -i 'C:\cygwin64\tmp\himawari_004_003_%04d.png' \
        -framerate 24 -i 'C:\cygwin64\tmp\himawari_005_003_%04d.png' \
        -framerate 24 -i 'C:\cygwin64\tmp\himawari_002_004_%04d.png' \
        -framerate 24 -i 'C:\cygwin64\tmp\himawari_003_004_%04d.png' \
        -framerate 24 -i 'C:\cygwin64\tmp\himawari_004_004_%04d.png' \
        -framerate 24 -i 'C:\cygwin64\tmp\himawari_005_004_%04d.png' \
        -framerate 24 -i 'C:\cygwin64\tmp\himawari_002_005_%04d.png' \
        -framerate 24 -i 'C:\cygwin64\tmp\himawari_003_005_%04d.png' \
        -framerate 24 -i 'C:\cygwin64\tmp\himawari_004_005_%04d.png' \
        -framerate 24 -i 'C:\cygwin64\tmp\himawari_005_005_%04d.png' \
        -framerate 24 -i 'C:\cygwin64\tmp\himawari_002_006_%04d.png' \
        -framerate 24 -i 'C:\cygwin64\tmp\himawari_003_006_%04d.png' \
        -framerate 24 -i 'C:\cygwin64\tmp\himawari_004_006_%04d.png' \
        -framerate 24 -i 'C:\cygwin64\tmp\himawari_005_006_%04d.png' \
        -framerate 24 -i 'C:\cygwin64\tmp\himawari_002_007_%04d.png' \
        -framerate 24 -i 'C:\cygwin64\tmp\himawari_003_007_%04d.png' \
        -framerate 24 -i 'C:\cygwin64\tmp\himawari_004_007_%04d.png' \
        -framerate 24 -i 'C:\cygwin64\tmp\himawari_005_007_%04d.png' \
        -framerate 24 -i 'C:\cygwin64\tmp\himawari_002_008_%04d.png' \
        -framerate 24 -i 'C:\cygwin64\tmp\himawari_003_008_%04d.png' \
        -framerate 24 -i 'C:\cygwin64\tmp\himawari_004_008_%04d.png' \
        -framerate 24 -i 'C:\cygwin64\tmp\himawari_005_008_%04d.png' \
	-vcodec libx264 \
	-movflags +faststart -profile:v high \
	-level 4.0 -bf 2 -g 12 -coder 1 -crf 18 -pix_fmt yuv420p \
	-filter_complex "[0:v][1:v][2:v][3:v]vstack=inputs=4[col1];\
                         [4:v][5:v][6:v][7:v]vstack=inputs=4[col2];\
                         [8:v][9:v][10:v][11:v]vstack=inputs=4[col3];\
                         [12:v][13:v][14:v][15:v]vstack=inputs=4[col4];\
                         [16:v][17:v][18:v][19:v]vstack=inputs=4[col5];\
                         [20:v][21:v][22:v][23:v]vstack=inputs=4[col6];\
                         [col1][col2][col3][col4][col5][col6]hstack=inputs=6[full];\
			 [full]scale=3840:-1[h];\
			 [h]crop=3840:2160[v]" \
	-map "[v]" -shortest \
	-r 24 \
	${date1}_himawari_taiwan.mp4

rm -rf /tmp/himawari*

echo "file '${date1}_himawari_taiwan.mp4'" >> join.txt
rm Himawari_Taiwan_201712.mp4
ffmpeg -f concat -safe 0 -i join.txt  -c copy Himawari_Taiwan_201712.mp4
