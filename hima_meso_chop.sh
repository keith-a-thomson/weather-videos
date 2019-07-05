cd ~/hima_meso
echo "Chopping"
for i in ./*_raw.mp4;
do
	fname=${i%.*}
	if [ ! -f ${fname}_p1.mp4 ] 
	then
		echo "Chopping $i"
		chop_black.sh $i
	fi
done

echo "Joining"
for i in ./*_raw.mp4;
do
	d=${i:2:8}
	output=${d}_himawari_mesoscale.mp4
	if [ ! -f $output ]
	then
		midnight=`date -d ${d} +"%s"`
		yesterday_t=$((midnight-10000))
		date_yesterday=`date -d @${yesterday_t} +'%Y%m%d'`
#		echo prev-${date_yesterday}
		file1=${date_yesterday}_himawari_mesoscale_raw_p2.mp4
		file2=${d}_himawari_mesoscale_raw_p1.mp4
		if [ -f $file1 ]
		then
			if [ -f $file2 ]
			then
				rm -rf tmpjoin.txt
				echo "file '${file1}'" >> tmpjoin.txt
				echo "file '${file2}'" >> tmpjoin.txt
				ffmpeg -f concat -safe 0 -i tmpjoin.txt -c copy ${output}
				rm -rf tmpjoin.txt
			fi
		fi
	fi
done
