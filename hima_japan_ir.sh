mkdir -p ${HOME}/hima_japan_ir
cd ${HOME}/hima_japan_ir

enable_curl=true
base_url_him=http://rammb-slider.cira.colostate.edu/data/imagery/
date1=$1$2$3
date2=$1-$2-$3

echo hjir-$date2
mkdir -p $date2

curllist=`curl -s -H  'User-Agent: Test' http://rammb-slider.cira.colostate.edu/data/json/himawari/japan/band_13/${date1}_by_hour.json | jq -r '.timestamps_int | .[] | .[]' | sort -n`
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
	if [ ! "${datelist}" = "" ]
	then
		mkdir -p download/${date2}
		rm -rf download/${date2}/*
		echo "  Downloading"
		url=${base_url_him}${date1}/himawari---japan
		curl -f -s --create-dirs -H 'User-Agent: Test' $url/band_13/{${datelist}}/01/[000-001]_[000-001].png -o download/${date2}/#1/#2_#3.png

		counter=0
		for i in download/${date2}/20*;
		do
			files=`ls -1 ${i}/ | wc -l`
			if [ "$files" -eq "4" ]
			then
				mv ${i} ${date2}/
				counter=$((counter+1))
			fi
		done
		echo "  ${counter} added"
		rm -rf download/${date2}
	fi
fi