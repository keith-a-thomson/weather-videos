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
base_url_him=http://rammb-slider.cira.colostate.edu/data/imagery/
date1=$1$2$3
date2=$1-$2-$3

echo -n "${5}ir0${4}-$date2"
mkdir -p ${date2}

curllist=`curl -s -H  'User-Agent: Test' http://rammb-slider.cira.colostate.edu/data/json/${data}/mesoscale_0${4}/band_13/${date1}_by_hour.json | jq -r '.timestamps_int | .[] | .[]' | sort -n`
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

		url=${base_url_him}${date1}/${data}---mesoscale_0${4}
		curl -f -s --retry 5 --retry-delay 5 --retry-max-time 60 --create-dirs -H 'User-Agent: Test' $url/band_13/{${datelist}}/00/000_000.png -o download/${date2}/#1/000_000.png

		for i in download/${date2}/20*;
		do
			files=`ls -1 ${i}/ | wc -l`
			if [ "$files" -eq "1" ]
			then
				mv ${i} ${date2}/
				counter=$((counter+1))
			fi
		done		
		rm -rf download/${date2}
	fi
	echo -e "\r${5}ir0${4}-$date2\t`ls -1 ${date2} | wc -l` (+${counter})"
fi
