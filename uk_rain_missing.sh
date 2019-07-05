mkdir -p ${HOME}/uk_rain
cd ${HOME}/uk_rain

base_url=https://max.nwstatic.co.uk/tiles3/

date1=$1$2$3
date2=$1-$2-$3

echo ukr-$date2
mkdir -p $date2

cd $date2

for dir in *; do
	files=`ls -1 ${dir}/ | wc -l`
	if [ ! "$files" -eq "64" ]
	then
		echo $dir $files
		for x in {59..66..1}
		do
			for y in {37..44..1}
			do
				if [ ! -f ${dir}/${y}_${x}.png ]
				then
					curl -s --retry 5 --retry-delay 5 --retry-max-time 60 --create-dirs --show-error ${base_url}${date1}/${dir}/8/${x}/${y}.png -o "${dir}/${y}_${x}.png"
					echo "missing ${dir}/${y}_${x}.png"
				fi
			done
		done
	fi
done

cd ..


