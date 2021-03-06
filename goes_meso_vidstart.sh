cd ${HOME}/goes_${5}_meso_0${4}/

date=$1$2$3
date_=$1-$2-$3
cd ${date_}

inblack=false
blackcount=0
nonblack=0

for i in ./*;    
do 
	current=${i:2}
	current_t=$(date -d "${current:0:8} ${current:8:2}:${current:10:2}:${current:12:2}" +'%s')

	files=`ls -1 ${current}/ | wc -l`
	if [ ! "$files" -eq "4" ];
	then
		if [ ! "$files" -eq "12" ];
		then
			continue
		fi
	fi
	cd ${current}
	b1=`identify -format "%[mean]" 000_000_2.png`
	b2=`identify -format "%[mean]" 001_000_2.png`
	b3=`identify -format "%[mean]" 000_001_2.png`
	b4=`identify -format "%[mean]" 001_001_2.png`
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
	#echo "i=$i";
	#echo $btotal
	#echo start=$start
	#echo inback=$inblack
	#echo blackcount=$blackcount
	#echo nonblack=$nonblack
	cd ..
done
cd ..

