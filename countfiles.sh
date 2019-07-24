for i in ./*;
do
	files=`ls -1 ${i}/ | wc -l`
	if [ ! "$files" -eq "${1}" ]
	then
		echo $i
	fi
done
