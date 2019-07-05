data=""
if [ "$5" = "hima" ]
then
	data="himawari"
fi
if [ "$5" = "goes" ]
then
	data="goes-16"
fi
if [ "$data" = "" ]
then
	echo "No specified"
	exit 0
fi


mkdir -p ${HOME}/${5}_meso_0${4}_ir
cd ${HOME}/${5}_meso_0${4}_ir

enable_curl=true
enable_vid=false
enable_gdrive=false

base_url_him=http://rammb-slider.cira.colostate.edu/data/imagery/

date1=$1$2$3
date2=$1-$2-$3

echo ${5}ir0${4}-$date2

mkdir -p $date2

#convert 000_000_red.png 000_000_green.png 000_000_blue.png -combine comb.png

#http://rammb-slider.cira.colostate.edu/data/json/himawari/mesoscale_01/map/white/latest_times_all.json
#http://rammb-slider.cira.colostate.edu/data/json/himawari/mesoscale_01/band_01/latest_times.json
curl -s -H  'User-Agent: Test' http://rammb-slider.cira.colostate.edu/data/json/${data}/mesoscale_0${4}/band_13/${date1}_by_hour.json | jq -r '.timestamps_int | .[] | .[]' | sort -n | while 
read line; do
        if [ ! -d ${date2}/${line} ]
        then
	        echo ${5}ir0${4}-$line
	        url=${base_url_him}${date1}/${data}---mesoscale_0${4}

	        if [ "$enable_curl" = true ];
		then
			mkdir -p ${date2}/tmp
			rm -f ${date2}/tmp/*

			curl -f -s --show-error -H 'User-Agent: Test' $url/band_13/${line}/00/000_000.png -o ${date2}/tmp/000_000.png

			files=`ls -1 ${date2}/tmp | wc -l`
			if [ "$files" -eq "1" ]
			then
				#cd ${date2}/tmp
				#convert 000_000_3.png 000_000_2.png 000_000_1.png -combine 000_000.png
				#convert 001_000_3.png 001_000_2.png 001_000_1.png -combine 001_000.png
				#convert 000_001_3.png 000_001_2.png 000_001_1.png -combine 000_001.png
				#convert 001_001_3.png 001_001_2.png 001_001_1.png -combine 001_001.png
				#rm *_*_*.png
				#cd ../..
				mv ${date2}/tmp ${date2}/${line}
			fi
			rm -rf ${date2}/tmp
		fi
	fi
done
