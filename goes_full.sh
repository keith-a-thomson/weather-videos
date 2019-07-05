if [ "$#" -ne 4 ]; 
then
	echo "Run as goes_full.sh yyyy mm dd 16"
	exit 0
fi

mkdir -p ${HOME}/goes_${4}_full
cd ${HOME}/goes_${4}_full

enable_curl=true
base_url_him=http://rammb-slider.cira.colostate.edu/data/imagery/
date1=$1$2$3
date2=$1-$2-$3

echo -n g${4}f-$date2
mkdir -p $date2

curllist=`curl -s -H  'User-Agent: Test' http://rammb-slider.cira.colostate.edu/data/json/goes-${4}/full_disk/geocolor/${date1}_by_hour.json | jq -r '.timestamps_int | .[] | .[]' | sort -n`
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
		url=${base_url_him}${date1}/goes-${4}---full_disk
		curl -f -s --retry 5 --retry-delay 5 --retry-max-time 60 --create-dirs -H 'User-Agent: Test' $url/geocolor/{${datelist}}/02/[000-003]_[000-003].png -o download/${date2}/#1/#2_#3.png

		for i in download/${date2}/20*;
		do
			files=`ls -1 ${i}/ | wc -l`
			if [ "$files" -eq "16" ]
			then
				mv ${i} ${date2}/
				counter=$((counter+1))
			fi
		done
		rm -rf download/${date2}
	fi
	echo -e "\rg${4}f-$date2\t`ls -1 ${date2} | wc -l` (+${counter})"
fi
