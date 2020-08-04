if [ "$#" -lt 2 ];
then
        echo "Run as month_vids.sh yyyy mm <code>"
        exit 0
fi

declare -a arr=(
				"goes_16_conus,Goes_16_Conus" 
				"goes_16_full,Goes_16_Full"
				"goes_17_conus,Goes_17_Conus" 
				"goes_17_full,Goes_17_Full"
				"hima_taiwan,Himawari_Taiwan"
				"hima_full,Himawari_Full"
				"goes_16_meso_01,Goes_16_Meso_01_Vis" 
				#"goes_meso_01_ir,Goes_16_Meso_01_IR"
				"goes_16_meso_02,Goes_16_Meso_02_Vis" 
				#"goes_meso_02_ir,Goes_16_Meso_02_IR"
				"goes_17_meso_01,Goes_17_Meso_01_Vis"
				"goes_17_meso_02,Goes_17_Meso_02_Vis"
				"hima_meso_01,Himawari_Mesoscale" 
				#"hima_meso_01_ir,Hima_Meso_01_IR"
				"hima_japan,Himawari_Japan" 
				"taiwan_cwb,Taiwan_Weather" 
				"uk_rain,Uk_Rain"
				)
for i in "${arr[@]}"
do
	dir=${i%,*};
	name=${i#*,};
	
	if [ "$#" -eq 3 ];
	then
		if [ ! "$3" == "$dir" ];
		then
			continue
		fi
	fi	
	
	cd /cygdrive/e/vid/$dir/
	if [ ! -f ../${name}_$1$2.mp4 ];
	then
		rm -f join_new.txt
		for f in ./$1$2*.mp4; do echo "file '$f'" >> join_new.txt; done
		ffmpeg -f concat -safe 0 -i join_new.txt -c copy ../${name}_$1$2.mp4
	fi
done
