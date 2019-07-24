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

echo ht-$date2

mkdir -p $date2
#for hour in {00..23};
for hour in {19..23};
do
    for minute in {00..50..10};
    do
	line=${date1}${hour}${minute}00
        if [ ! -d ${date2}/${line} ]
        then
	        echo ht-$line
	        url=${base_url_him}${date1}/himawari---full_disk/geocolor/${line}

	        if [ "$enable_curl" = true ];
		then
			mkdir -p ${date2}/tmp
			rm -f ${date2}/tmp/*

			for x in {002..005..1}
			do
				for y in {003..008..1}
				do
					mycurl.sh  $url/04/${x}_${y}.png ${date2}/tmp/${x}_${y}.png &
				done
				wait
			done

			files=`ls -1 ${date2}/tmp | wc -l`
			if [ "$files" -eq "24" ]
			then
				mv ${date2}/tmp ${date2}/${line}
			fi
		fi
	fi
    done
done
