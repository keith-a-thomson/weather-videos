current=`date +"%s"`
current_date=`date +'%Y-%m-%d'`
future=`date -d "${current_date} $1" +"%s"`
diff=$((future-current))
if (( $diff < 0 ));
then
	diff=$(( (60*60*24) + $diff ))
fi

echo "Sleep for $diff seconds"
sleep ${diff}
date
