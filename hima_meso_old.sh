mkdir -p ~/hima_meso
cd ~/hima_meso

enable_curl=true
enable_vid=false
enable_gdrive=false

base_url_him=http://rammb-slider.cira.colostate.edu/data/imagery/

date1=$1$2$3
date2=$1-$2-$3

echo hm-$date2

mkdir -p $date2

#convert 000_000_red.png 000_000_green.png 000_000_blue.png -combine comb.png

#http://rammb-slider.cira.colostate.edu/data/json/himawari/mesoscale_01/map/white/latest_times_all.json
#http://rammb-slider.cira.colostate.edu/data/json/himawari/mesoscale_01/band_01/latest_times.json
curl -s -H  'User-Agent: Test' http://rammb-slider.cira.colostate.edu/data/json/himawari/mesoscale_01/band_01/${date1}_by_hour.json | jq -r '.timestamps_int | .[] | .[]' | sort -n | while 
read line; do
        if [ ! -d ${date2}/${line} ]
        then
	        echo hm-$line
	        url=${base_url_him}${date1}/himawari---mesoscale_01

	        if [ "$enable_curl" = true ];
		then
			mkdir -p ${date2}/tmp
			rm -f ${date2}/tmp/*

			curl -s --show-error -H 'User-Agent: Test' $url/band_0[1-3]/${line}/01/[000-001]_[000-001].png -o ${date2}/tmp/#2_#3_#1.png

			files=`ls -1 ${date2}/tmp | wc -l`
			if [ "$files" -eq "12" ]
			then
				cd ${date2}/tmp
				convert 000_000_3.png 000_000_2.png 000_000_1.png -combine 000_000.png
				convert 001_000_3.png 001_000_2.png 001_000_1.png -combine 001_000.png
				convert 000_001_3.png 000_001_2.png 000_001_1.png -combine 000_001.png
				convert 001_001_3.png 001_001_2.png 001_001_1.png -combine 001_001.png
				rm *_*_*.png
				cd ../..
				mv ${date2}/tmp ${date2}/${line}
			fi
		fi
	fi
done
