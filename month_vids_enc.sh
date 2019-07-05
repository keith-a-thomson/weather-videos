if [ "$#" -lt 2 ];
then
        echo "Run as month_vids_enc.sh yyyy mm <code>"
        exit 0
fi

declare -a arr=(
				"Goes_16_Conus,toh265_archive.sh" 
				"Goes_16_Full,toh265_archive.sh"
				"Goes_17_Conus,toh265_archive.sh" 
				"Goes_17_Full,toh265_archive.sh"
				"Himawari_Taiwan,toh265_archive.sh"
				"Himawari_Full,toh265_archive.sh"
				"Goes_16_Meso_01_Vis,toh265_archive_60fps.sh" 
				"Goes_16_Meso_02_Vis,toh265_archive_60fps.sh" 
				"Goes_16_Meso_01_IR,toh265_archive_60fps.sh"
				"Goes_16_Meso_02_IR,toh265_archive_60fps.sh"
				"Goes_17_Meso_01_Vis,toh265_archive_60fps.sh"
				"Goes_17_Meso_02_Vis,toh265_archive_60fps.sh"
				"Himawari_Mesoscale,toh265_archive.sh" 
				"Hima_Meso_01_IR,toh265_archive_60fps.sh"
				"Himawari_Japan,toh265_archive.sh" 
				"Taiwan_Weather,toh265_archive.sh"
				)
cd /cygdrive/e/vid
for i in "${arr[@]}"
do
	file=${i%,*};
	encode=${i#*,};
	
	if [ "$#" -eq 3 ];
	then
		if [ ! "$3" == "$file" ];
		then
			continue
		fi
	fi
	
	if [ ! -f ../x265_crf20_${file}_$1$2.mp4 ];
	then
		$encode ${file}_$1$2.mp4
	fi
done
