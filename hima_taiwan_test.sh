mkdir -p ${HOME}/hima_taiwan
cd ${HOME}/hima_taiwan

enable_curl=true
enable_vid=false
enable_gdrive=false

base_url_him=http://rammb-slider.cira.colostate.edu/data/imagery/

#date2=`date +'%Y-%m-%d'`
#date1=20171125
date1=$1$2$3
#date2=2017-11-25
date2=$1-$2-$3

#echo $date1
echo "Running $date2"

mkdir -p $date2

curl -H  'User-Agent: Test' http://rammb-slider.cira.colostate.edu/data/json/himawari/full_disk/geocolor/${date1}_by_hour.json | jq -r '.timestamps_int | .[] | .[]' | sort -n | while 
read line; do
#        echo $line
	if [ ! -d "${date2}/${line}" ]
	then
		echo $line
		mkdir -p ${date2}/${line}
	        url=${base_url_him}${date1}/himawari---full_disk/geocolor/${line}

	        if [ "$enable_curl" = true ];
		then
			for x in {002..005..1}
			do
				for y in {003..008..1}
				do
					curl --silent --show-error -H 'User-Agent: Test' $url/04/${x}_${y}.png -o ${date2}/${line}/${x}_${y}.png
	                                if [ ! $? -eq 0 ]; 
					then
	                                    echo "curl --silent --show-error -H 'User-Agent: Test' $url/04/${x}_${y}.png"
	                                fi
				done
			done
		fi
	fi
done
