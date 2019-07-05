year=2017
month=12
days=31

cd $1
for day in {01..31}
do
	dir=$year-$month-$day
	if [ -d $dir ];
	then
		echo "$dir `ls -1 $dir | wc -l`"
		cd $dir
		for png in */*.png;
		do
			type=`file $png | grep -v "PNG image data"`
			if [ ! -z "$type" ]
			then
				echo "     $png-$type"
			fi
		done
		if [ ! -d "${year}${month}${day}000000" ]
		then
			echo "     Midnight missing"
		fi
		if [ ! -d "${year}${month}${day}235000" ]
		then
			echo "     Last one missing"
		fi
		cd ..
	else
		echo $dir - not found
	fi
done
