if [ "$2" = "yesterday" ];
then
	year=`TZ=GMT+24 date +'%Y'`
	month=`TZ=GMT+24 date +'%m'`
	day=`TZ=GMT+24 date +'%d'`
else
	year=`date +'%Y'`
	month=`date +'%m'`
	day=`date +'%d'`
fi

echo $year-$month-$day

$1 $year $month $day
