cd ~

process_hima_full=true
process_hima_taiwan=true
process_goes_16_full=true
process_goes_17_full=true
process_goes_16_conus=true
process_goes_17_conus=true
process_goes_meso_01_ir=true
process_goes_meso_02_ir=true
process_hima_meso_01_ir=true
process_hima_japan=false
process_hima_meso=false

if [ ! -z "$4" ]
then
	echo "Variable passed $4"
	process_hima_full=false
	process_hima_taiwan=false
	process_goes_16_full=false
	process_goes_17_full=false
	process_goes_16_conus=false
	process_goes_17_conus=false
	process_goes_meso_01_ir=false
	process_goes_meso_02_ir=false
	process_hima_meso_01_ir=false
	process_hima_japan=false
    process_hima_meso=false

	if [ "$4" = "hima_full" ]
	then
		process_hima_full=true
	fi

	if [ "$4" = "hima_taiwan" ]
	then
		process_hima_taiwan=true
	fi

	if [ "$4" = "goes_16_full" ]
	then
		process_goes_16_full=true
	fi

    if [ "$4" = "goes_17_full" ]
    then
		process_goes_17_full=true
    fi

	if [ "$4" = "goes_16_conus" ]
	then
		process_goes_16_conus=true
	fi

    if [ "$4" = "goes_17_conus" ]
    then
            process_goes_17_conus=true
    fi
	
	if [ "$4" = "goes_meso_01_ir" ]
	then
		process_goes_meso_01_ir=true
	fi

	if [ "$4" = "goes_meso_02_ir" ]
	then
		process_goes_meso_02_ir=true
	fi
	
	if [ "$4" = "hima_meso_01_ir" ]
	then
		process_hima_meso_01_ir=true
	fi

	if [ "$4" = "hima_japan" ]
	then
		process_hima_japan=true
	fi

        if [ "$4" = "hima_meso" ]
        then
                process_hima_meso=true
        fi

fi

if [ "$process_hima_full" = true ]
then
	hima_full_video.sh $1 $2 $3 |& tee -a Himawari_Full.txt
fi

if [ "$process_hima_taiwan" = true ]
then
	hima_taiwan_video.sh $1 $2 $3 |& tee -a Himawari_Taiwan.txt
fi

if [ "$process_goes_16_full" = true ]
then
	goes_full_video.sh $1 $2 $3 16 |& tee -a Goes_Full.txt
fi

if [ "$process_goes_17_full" = true ]
then
        goes_full_video.sh $1 $2 $3 17 |& tee -a Goes_Full_17.txt
fi

if [ "$process_goes_16_conus" = true ]
then
	goes_conus_video.sh $1 $2 $3 16 |& tee -a Goes_Conus.txt
fi

if [ "$process_goes_17_conus" = true ]
then
        goes_conus_video.sh $1 $2 $3 17 |& tee -a Goes_Conus_17.txt
fi

if [ "$process_goes_meso_01_ir" = true ]
then
	irch13_video.sh $1 $2 $3 1 goes |& tee -a goes_meso_01_ir.txt
fi

if [ "$process_goes_meso_02_ir" = true ]
then
	irch13_video.sh $1 $2 $3 2 goes |& tee -a goes_meso_02_ir.txt
fi

if [ "$process_hima_meso_01_ir" = true ]
then
	irch13_video.sh $1 $2 $3 1 hima |& tee -a hima_meso_01_ir.txt
fi

if [ "$process_hima_japan" = true ]
then
	hima_japan_video.sh $1 $2 $3
fi

if [ "$process_hima_meso" = true ]
then
        hima_meso_video.sh $1 $2 $3
fi

