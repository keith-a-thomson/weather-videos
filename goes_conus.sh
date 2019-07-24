if [ "$#" -ne 4 ];
then
        echo "Run as goes_conus.sh yyyy mm dd 16"
        exit 0
fi

mkdir -p ${HOME}/goes_${4}_conus
cd ${HOME}/goes_${4}_conus

enable_curl=true
base_url_him=http://rammb-slider.cira.colostate.edu/data/imagery/
date1=$1$2$3
date2=$1-$2-$3
 
echo -n g${4}c-$date2
mkdir -p $date2

curllist=`curl -s -H  'User-Agent: Test' http://rammb-slider.cira.colostate.edu/data/json/goes-${4}/conus/geocolor/${date1}_by_hour.json | jq -r '.timestamps_int | .[] | .[]' | sort -n`
while read line; do
	if [ ! -d ${date2}/${line} ]
	then
		datelist=${datelist},${line}
	fi
done <<< "${curllist}"
# Remove first ,
datelist="${datelist:1}"

if [ "$enable_curl" = true ];
then
	counter=0
	if [ ! "${datelist}" = "" ]
	then
		mkdir -p download/${date2}
		rm -rf download/${date2}/*
		url=${base_url_him}${date1}/goes-${4}---conus
		curl -f -s --retry 5 --retry-delay 5 --retry-max-time 60 --create-dirs -H 'User-Agent: Test' $url/geocolor/{${datelist}}/03/[001-006]_[000-007].png -o download/${date2}/#1/#2_#3.png

		for i in download/${date2}/20*;
		do
			files=`ls -1 ${i}/ | wc -l`
			if [ "$files" -eq "48" ]
			then
				mv ${i} ${date2}/
				counter=$((counter+1))
			fi
		done
		
		rm -rf download/${date2}
	fi
	echo -e "\rg${4}c-$date2\t`ls -1 ${date2} | wc -l` (+${counter})"
fi

