cd ~

process_hima_full=true
process_hima_taiwan=true
process_goes_full=true
process_goes_conus=true
process_goes_meso_01_ir=true
process_goes_meso_02_ir=true
process_hima_meso_01_ir=true

if [ ! -z "$4" ]
then
	echo "Variable passed"
	process_hima_full=false
	process_hima_taiwan=false
	process_goes_full=false
	process_goes_conus=false
	process_goes_meso_01_ir=false
	process_goes_meso_02_ir=false
	process_hima_meso_01_ir=false

	if [ "$4" = "hima_full" ]
	then
		process_hima_full=true
	fi

	if [ "$4" = "hima_taiwan" ]
	then
		process_hima_taiwan=true
	fi

	if [ "$4" = "goes_full" ]
	then
		process_goes_full=true
	fi

	if [ "$4" = "goes_conus" ]
	then
		process_goes_conus=true
	fi
	
	if [ "$4" = "goes_meso_01_ir" ]
	then
		process_goes_meso_01_ir=true
	fi

	if [ "$4" = "goes_meso_02_ir" ]
	then
		process_goes_meso_02_ir=true
	fi
	
	if [ "$4" = "hiima_meso_01_ir" ]
	then
		process_hima_meso_01_ir=true
	fi
fi

if [ "$process_hima_full" = true ]
then
	hima_full_video.sh $1 $2 $3 |& tee -a hima_full.txt
fi

if [ "$process_hima_taiwan" = true ]
then
	hima_taiwan_video.sh $1 $2 $3 |& tee -a hima_taiwan.txt
fi

if [ "$process_goes_full" = true ]
then
	goes_full_video.sh $1 $2 $3 |& tee -a goes_full.txt
fi

if [ "$process_goes_conus" = true ]
then
	goes_conus_video.sh $1 $2 $3 |& tee -a goes_conus.txt
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



exit 0

# UPLOAD ----------------------

if [ "$process_hima_full" = true ]
then
	#upload.sh hf $1 $2 $3
fi

if [ "$process_hima_taiwan" = true ]
then
	#upload.sh hf $1 $2 $3
fi

if [ "$process_goes_full" = true ]
then
	upload.sh gf $1 $2 $3
fi

if [ "$process_goes_conus" = true ]
then
	upload.sh gc $1 $2 $3
fi

if [ "$process_goes_meso_01_ir" = true ]
then
	upload.sh gm1ir $1 $2 $3
fi

if [ "$process_goes_meso_02_ir" = true ]
then
	upload.sh gm2ir $1 $2 $3
fi

if [ "$process_hima_meso_01_ir" = true ]
then
	upload.sh hf $1 $2 $3
fi
