curlopts="--silent --show-error"
#echo $1
#echo $2
#echo ${curlopts}
curl ${curlopts} --max-time 60 -H 'User-Agent: Test' $1 -o $2
if [ ! $? -eq 0 ]; 
then
	echo "curl ${curlopts} -H 'User-Agent: Test' $1 -o $2"
	rm -f $2
fi
