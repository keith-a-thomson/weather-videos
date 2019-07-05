cd ${HOME}/hima_japan/
date=$1$2$3
date_=$1-$2-$3
cd ${date_}

inblack=false
blackcount=0
nonblack=0
for i in ./*;    
do 
#	echo "i=$i"

	current=${i:2}
	current_t=$(date -d "${current:0:8} ${current:8:2}:${current:10:2}:${current:12:2}" +'%s')

	hour=${current:8:2}
	if (( 10#$hour < 15 ));
	then
		# Only start looking for black after 4pm UTC
		continue;
	fi
	
	files=`ls -1 ${current}/ | wc -l`
	if [ ! "$files" -eq "48" ];
	then
		continue
	else
		cd ${current}
		b1=`identify -format "%[mean]" 000_001_1.png`
		b2=`identify -format "%[mean]" 003_000_1.png`
		b3=`identify -format "%[mean]" 000_003_1.png`
		b4=`identify -format "%[mean]" 003_002_1.png`
		btotal=$(awk "BEGIN {printf(\"%.0f\n\", ${b1} + ${b2} + ${b3} + ${b4}); exit}")
		if (( btotal > 200 ));
		then
			# We have a non-black image
			nonblack=$(($nonblack+1));
			if [ "$inblack" = true ];
			then
				# So we will start here if we reach 60 non-black images
				start=${current}
				inblack=false
			fi
			if (( nonblack > 60));
			then
				if [ ! "$start" = "" ];
				then
					echo ${start}
					exit 0
				fi
			fi
		else
			# A black image
			blackcount=$(($blackcount+1));
			start=
			nonblack=0
			if (( blackcount > 60 ));
			then
				inblack=true
			fi
		fi
		cd ..
	fi
done
cd ..

