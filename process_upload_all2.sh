download_all.sh $1 $2 $3

date2=$1-$2-$3
midnight=`date -d ${date2} +"%s"`
tomorrow_t=$((midnight+86400+600))
date_tomorrow=`date -d @${tomorrow_t} +'%Y %m %d'`
download_all.sh ${date_tomorrow}

hima_full.sh   $1 $2 $3

goes_full.sh   $1 $2 $3 16 &

process_main.sh $1 $2 $3 hima_full
wait
upload.sh hf $1 $2 $3 &
goes_full.sh   $1 $2 $3 17 &

process_main.sh $1 $2 $3 goes_16_full
wait
upload.sh g16f $1 $2 $3 &
goes_conus.sh  $1 $2 $3 16 &

process_main.sh $1 $2 $3 goes_17_full
wait
upload.sh g17f $1 $2 $3 &
goes_conus.sh  $1 $2 $3 17 &

process_main.sh $1 $2 $3 goes_16_conus
wait
upload.sh g16c $1 $2 $3 &
hima_taiwan.sh $1 $2 $3 &

process_main.sh $1 $2 $3 goes_17_conus
wait
upload.sh g17c $1 $2 $3 &
goes_meso.sh   $1 $2 $3 1 16 &

process_main.sh $1 $2 $3 hima_taiwan
wait
upload.sh ht $1 $2 $3 &
goes_meso.sh   $1 $2 $3 2 16 &

process_laters.sh $1 $2 $3 goes_16_meso_01
wait
upload.sh g16m1 $1 $2 $3 &
goes_meso.sh   $1 $2 $3 1 17 &

process_laters.sh $1 $2 $3 goes_16_meso_02
wait
upload.sh g16m2 $1 $2 $3 &
goes_meso.sh   $1 $2 $3 2 17 &

process_laters.sh $1 $2 $3 goes_17_meso_01
wait
upload.sh g17m1 $1 $2 $3 &

process_laters.sh $1 $2 $3 goes_17_meso_02
wait
upload.sh g17m2 $1 $2 $3

