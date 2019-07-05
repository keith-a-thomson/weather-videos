cd ~

process_goes_16_meso_01=true
process_goes_16_meso_02=true
process_goes_17_meso_01=true
process_goes_17_meso_02=true
if [ ! -z "$4" ]
then
	echo "Variable passed"
	process_goes_16_meso_01=false
	process_goes_16_meso_02=false
        process_goes_17_meso_01=false
        process_goes_17_meso_02=false

	if [ "$4" = "goes_16_meso_01" ]
	then
		process_goes_16_meso_01=true
	fi

        if [ "$4" = "goes_16_meso_02" ]
        then
                process_goes_16_meso_02=true
        fi

        if [ "$4" = "goes_17_meso_01" ]
        then
                process_goes_17_meso_01=true
        fi

        if [ "$4" = "goes_17_meso_02" ]
        then
                process_goes_17_meso_02=true
        fi
fi

if [ "$process_goes_16_meso_01" = true ]
then
        goes_meso_video.sh $1 $2 $3 1 16
fi

if [ "$process_goes_16_meso_02" = true ]
then
        goes_meso_video.sh $1 $2 $3 2 16
fi

if [ "$process_goes_17_meso_01" = true ]
then
        goes_meso_video.sh $1 $2 $3 1 17
fi

if [ "$process_goes_17_meso_02" = true ]
then
        goes_meso_video.sh $1 $2 $3 2 17
fi



