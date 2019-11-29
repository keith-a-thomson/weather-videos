mkdir -p ${HOME}/hima_full
cd ${HOME}/hima_full

enable_curl=true
base_url_him=https://rammb-slider.cira.colostate.edu/data/imagery/
date1=$1$2$3
date2=$1-$2-$3
chunksize=20

echo -ne "\rhf-$date2"
mkdir -p $date2

exec 200>${HOME}/locks/hima_full_${date2}_lock 
flock -xn 200 || exit 1

curllist=`curl -L -s -H  'User-Agent: Test' https://rammb-slider.cira.colostate.edu/data/json/himawari/full_disk/geocolor/${date1}_by_hour.json | jq -r '.timestamps_int | .[] | .[]' | sort -n`
ARRINDEX=0
declare -a DATEARRAY
while read line; do
	if [ ! -d ${date2}/${line} ]
	then
		DATEARRAY[$ARRINDEX]=${line}
		ARRINDEX=$(( $ARRINDEX + 1 ))
	fi
done <<< "${curllist}"

if [ "$enable_curl" = true ];
then
	counter=0
	if (( ARRINDEX > 0 ));
	then
		mkdir -p download/${date2}
		rm -rf download/${date2}/*

		url=${base_url_him}${date1}/himawari---full_disk
		for((arridx=0; arridx < ${#DATEARRAY[@]}; arridx+=$chunksize))
		do
			arraypart=( "${DATEARRAY[@]:arridx:chunksize}")
			chunk=`echo ${arraypart[*]}| tr ' ' ,`
			
			curl -L -f -s --retry 5 --retry-delay 5 --retry-max-time 60 --create-dirs -H 'User-Agent: Test' $url/geocolor/{${chunk}}/02/[000-003]_[000-003].png -o download/${date2}/#1/#2_#3.png
			
			for i in download/${date2}/20*;
			do
				files=`ls -1 ${i}/ | wc -l`
				if [ "$files" -eq "16" ]
				then
					mv ${i} ${date2}/
					counter=$((counter+1))
				fi
			done
			echo -ne "\rhf-$date2\t`ls -1 ${date2} | wc -l` (+${counter})"			
			rm -rf download/${date2}
		done
	fi
	echo -e "\rhf-$date2\t`ls -1 ${date2} | wc -l` (+${counter})"
fi
