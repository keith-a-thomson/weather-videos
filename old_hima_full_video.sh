cd ~/hima_full/
pwd
#date1=`date +'%Y%m%d'`
#date2=`date +'%Y-%m-%d'`
#date_yesterday=`TZ=GMT+24 date +%Y%m%d`

date1=$1$2$3
date2=$1-$2-$3

cd ${date2}
rm -rf /tmp/himawari*

x=0; 
for i in ./*;    
do 
	echo $i
	counter=$(printf %04d $x); 

	cp "$i/000_000.png" /tmp/himawari_0_0_"$counter".png;    
        cp "$i/000_001.png" /tmp/himawari_0_1_"$counter".png;
        cp "$i/000_002.png" /tmp/himawari_0_2_"$counter".png;
        cp "$i/000_003.png" /tmp/himawari_0_3_"$counter".png;
        cp "$i/001_000.png" /tmp/himawari_1_0_"$counter".png;
        cp "$i/001_001.png" /tmp/himawari_1_1_"$counter".png;
        cp "$i/001_002.png" /tmp/himawari_1_2_"$counter".png;
        cp "$i/001_003.png" /tmp/himawari_1_3_"$counter".png;
        cp "$i/002_000.png" /tmp/himawari_2_0_"$counter".png;
        cp "$i/002_001.png" /tmp/himawari_2_1_"$counter".png;
        cp "$i/002_002.png" /tmp/himawari_2_2_"$counter".png;
        cp "$i/002_003.png" /tmp/himawari_2_3_"$counter".png;
        cp "$i/003_000.png" /tmp/himawari_3_0_"$counter".png;
        cp "$i/003_001.png" /tmp/himawari_3_1_"$counter".png;
        cp "$i/003_002.png" /tmp/himawari_3_2_"$counter".png;
        cp "$i/003_003.png" /tmp/himawari_3_3_"$counter".png;

	x=$(($x+1)); 
done
cd ..

ffmpeg -f image2 \
	-framerate 24 -i 'C:\cygwin64\tmp\himawari_0_0_%04d.png' \
        -framerate 24 -i 'C:\cygwin64\tmp\himawari_1_0_%04d.png' \
        -framerate 24 -i 'C:\cygwin64\tmp\himawari_2_0_%04d.png' \
        -framerate 24 -i 'C:\cygwin64\tmp\himawari_3_0_%04d.png' \
        -framerate 24 -i 'C:\cygwin64\tmp\himawari_0_1_%04d.png' \
        -framerate 24 -i 'C:\cygwin64\tmp\himawari_1_1_%04d.png' \
        -framerate 24 -i 'C:\cygwin64\tmp\himawari_2_1_%04d.png' \
        -framerate 24 -i 'C:\cygwin64\tmp\himawari_3_1_%04d.png' \
        -framerate 24 -i 'C:\cygwin64\tmp\himawari_0_2_%04d.png' \
        -framerate 24 -i 'C:\cygwin64\tmp\himawari_1_2_%04d.png' \
        -framerate 24 -i 'C:\cygwin64\tmp\himawari_2_2_%04d.png' \
        -framerate 24 -i 'C:\cygwin64\tmp\himawari_3_2_%04d.png' \
        -framerate 24 -i 'C:\cygwin64\tmp\himawari_0_3_%04d.png' \
        -framerate 24 -i 'C:\cygwin64\tmp\himawari_1_3_%04d.png' \
        -framerate 24 -i 'C:\cygwin64\tmp\himawari_2_3_%04d.png' \
        -framerate 24 -i 'C:\cygwin64\tmp\himawari_3_3_%04d.png' \
	-vcodec libx264 \
	-movflags +faststart -profile:v high \
	-level 4.0 -bf 2 -g 12 -coder 1 -crf 18 -pix_fmt yuv420p \
	-filter_complex "[0:v][1:v]vstack[a];[a][2:v]vstack[b];[b][3:v]vstack[row1];\
                         [4:v][5:v]vstack[a];[a][6:v]vstack[b];[b][7:v]vstack[row2];\
                         [row1][row2]hstack[row12];\
			 [8:v][9:v]vstack[a];[a][10:v]vstack[b];[b][11:v]vstack[row3];\
                         [12:v][13:v]vstack[a];[a][14:v]vstack[b];[b][15:v]vstack[row4];\
                         [row3][row4]hstack[row34];
			 [row12][row34]hstack[full];
			 [full]scale=-1:2160[v]" \
	-map "[v]" -shortest \
	-r 24 \
	${date1}_himawari.mp4

echo "file '${date1}_himawari.mp4'" >> join.txt

rm Himawari_201712.mp4
ffmpeg -f concat -safe 0 -i join.txt  -c copy Himawari_201712.mp4

rm -rf /tmp/himawari*

