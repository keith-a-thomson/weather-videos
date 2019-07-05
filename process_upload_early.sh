process_main.sh $1 $2 $3 hima_meso
upload.sh hm $1 $2 $3 &

process_main.sh $1 $2 $3 hima_japan
wait
upload.sh hj $1 $2 $3
