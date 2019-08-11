mkdir -p ${HOME}/hima_japan
cd ${HOME}/hima_japan

enable_curl=true
base_url_him=https://rammb-slider.cira.colostate.edu/data/imagery/
date1=$1$2$3
date2=$1-$2-$3
enable_colour=false

echo -n "hj-$date2"
mkdir -p $date2

curl -s -H  'User-Agent: Test' https://rammb-slider.cira.colostate.edu/data/json/himawari/japan/band_03/${date1}_by_hour.json | jq -r '.timestamps_int | .[] | .[]' > ${date2}/tmp3.txt
if [ "${enable_colour}" = true ];
then
	curl -s -H  'User-Agent: Test' https://rammb-slider.cira.colostate.edu/data/json/himawari/japan/band_01/${date1}_by_hour.json | jq -r '.timestamps_int | .[] | .[]' > ${date2}/tmp1.txt
	curl -s -H  'User-Agent: Test' https://rammb-slider.cira.colostate.edu/data/json/himawari/japan/band_02/${date1}_by_hour.json | jq -r '.timestamps_int | .[] | .[]' > ${date2}/tmp2.txt

	cat ${date2}/tmp1.txt ${date2}/tmp2.txt | sort -n | uniq -d > ${date2}/tmp12.txt
	cat ${date2}/tmp12.txt ${date2}/tmp3.txt | sort -n | uniq -d > ${date2}/times.txt
	rm ${date2}/tmp1.txt
	rm ${date2}/tmp2.txt
	rm ${date2}/tmp3.txt
	rm ${date2}/tmp12.txt
else
	mv ${date2}/tmp3.txt ${date2}/times.txt
fi

while read line; do
	if [ ! -d ${date2}/${line} ]
	then
		datelist=${datelist},${line}
	fi
done < "${date2}/times.txt"
rm ${date2}/times.txt
# Remove first ,
datelist="${datelist:1}"

if [ "$enable_curl" = true ];
then
	counter=0
	if [ ! "${datelist}" = "" ]
	then
		mkdir -p download/${date2}
		rm -rf download/${date2}/*
		url=${base_url_him}${date1}/himawari---japan
		if [ "${enable_colour}" = true ];
		then
			curl -f -s --create-dirs -H 'User-Agent: Test' $url/band_0[1-3]/{${datelist}}/02/[000-003]_[000-003].png -o download/${date2}/#2/#3_#4_#1.png
		else
			curl -f -s --create-dirs -H 'User-Agent: Test' $url/band_03/{${datelist}}/02/[000-003]_[000-003].png -o download/${date2}/#1/#2_#3_3.png
		fi

		for i in download/${date2}/20*;
		do
			files=`ls -1 ${i}/ | wc -l`
			if [ "$files" -eq "48" ]
			then
				mv ${i} ${date2}/
				counter=$((counter+1))
			fi
			if [ "$files" -eq "16" ]
			then
				mv ${i} ${date2}/
				counter=$((counter+1))
			fi
		done
		rm -rf download/${date2}
	fi
	echo -e "\rhj-$date2\t`ls -1 ${date2} | wc -l` (+${counter})"
fi
