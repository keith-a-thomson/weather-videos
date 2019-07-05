current=`date +"%s"`
current_date=`date +'%Y-%m-%d'`
future=`date -d "${current_date} $1" +"%s"`

diff=$((future-current))
if (( $diff < 0 ));
then
	tomorrow_date=`date +'%y-%m-%d'`
	future=`TZ=$TZ+24 date -d "${current_date} $1" +"%s"`
	diff=$((future-current))
fi

echo "Sleep for $diff seconds"
sleep ${diff}
date
