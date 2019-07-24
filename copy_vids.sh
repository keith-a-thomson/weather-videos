declare -a arr=("goes_16_conus" "goes_16_full" "hima_taiwan" "hima_full"
                "goes_16_meso_01" "goes_meso_01_ir"
				"goes_16_meso_02" "goes_meso_02_ir"
				"goes_17_meso_01"
				"goes_17_meso_02"
				"hima_meso_01" "hima_meso_01_ir"
				"hima_japan" "taiwan_cwb" "uk_rain")
for i in "${arr[@]}"
do
   echo "$i"
   cp -p -u -v //keith-lapwing/keith/$i/20*.mp4 /cygdrive/e/vid/$i/
done