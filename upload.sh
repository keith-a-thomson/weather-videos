year=$2
month=$3
day=$4
type=
file=
tags=satellite,imagery,ocean,waves,wind,earth,sea,timelapse,clouds,typhoon,hurricane,cyclone,snow,sun,storm,rain,tropical
title=
description="Data scraped from http://rammb-slider.cira.colostate.edu"
token=request.token
playlist=

if [ "$1" = "g16c" ]; then
	type="goes_16_conus"
	file=${year}${month}${day}_${type}.mp4
	playlist="PLnDVpcUXOcQY9_eulIaAvheu2otuHH3mW"
	tags="$tags,goes,goes-east,conus,america,north america,USA,Florida,East Coast"
	title="GOES-16 CONUS - $year/${month}/${day}"
	description="${description}\nGeoColor Layer from http://www.cira.colostate.edu/ \nA frame every 5 minutes"

elif [ "$1" = "g17c" ]; then
	type="goes_17_conus"
	file=${year}${month}${day}_${type}.mp4
	playlist="PLnDVpcUXOcQY9_eulIaAvheu2otuHH3mW"
	tags="$tags,goes,goes-west,conus,america,north america,USA,West Coast"
	title="GOES-17 CONUS - $year/${month}/${day}"
	description="${description}\nGeoColor Layer from http://www.cira.colostate.edu/ \nA frame every 5 minutes\n"

elif [ "$1" = "g16f" ]; then
	type="goes_16_full"
	file=${year}${month}${day}_goes_16.mp4
	playlist="PLnDVpcUXOcQbAESB05_m3du8uV11uLoFO"
	tags="$tags,goes,goes-east,full disk,america,south america,north america,USA,Brazil,Amazon,Rainforest,Chile"
	title="GOES-16 Full Disk - $year/${month}/${day}"
	description="${description}\nGeoColor Layer from http://www.cira.colostate.edu/ \nA frame every 15 minutes"

elif [ "$1" = "g17f" ]; then
	type="goes_17_full"
	file=${year}${month}${day}_goes_17.mp4
	playlist="PLnDVpcUXOcQbAESB05_m3du8uV11uLoFO"
	tags="$tags,goes,goes-west,full disk,america,pacific,hawaii"
	title="GOES-17 Full Disk - $year/${month}/${day}"
	description="${description}\nGeoColor Layer from http://www.cira.colostate.edu/ \nA frame every 15 minutes\n"

elif [ "$1" = "g16m1" ]; then
	type="goes_16_meso_01"
	file=${year}${month}${day}_goes_16_mesoscale01.mp4
	playlist="PLnDVpcUXOcQa2T2ReAIOf5fues4fSANU2"
	tags="$tags,goes,goes-east,conus,america,north america,USA,meso,mesoscale"
	title="GOES-16 (East) Mesoscale 01 - $year/${month}/${day}"
	description="${description}\nUsing the red band images.\nA frame every 60 seconds"

elif [ "$1" = "g16m2" ]; then
	type="goes_16_meso_02"
	file=${year}${month}${day}_goes_16_mesoscale02.mp4
	playlist="PLnDVpcUXOcQbx3mEiX1yLfIhRRaCOoL4X"
	tags="$tags,goes,goes-east,conus,america,north america,USA,meso,mesoscale"
	title="GOES-16 (East) Mesoscale 02 - $year/${month}/${day}"
	description="${description}\nUsing the red band images.\nA frame every 60 seconds"

elif [ "$1" = "g17m1" ]; then
	type="goes_17_meso_01"
	file=${year}${month}${day}_goes_17_mesoscale01.mp4
	playlist="PLnDVpcUXOcQa2T2ReAIOf5fues4fSANU2"
	tags="$tags,goes,goes-east,conus,america,north america,USA,meso,mesoscale"
	title="GOES-17 (West) Mesoscale 01 - $year/${month}/${day}"
	description="${description}\nUsing the red band images.\nA frame every 60 seconds"

elif [ "$1" = "g17m2" ]; then
	type="goes_17_meso_02"
	file=${year}${month}${day}_goes_17_mesoscale02.mp4
	playlist="PLnDVpcUXOcQbx3mEiX1yLfIhRRaCOoL4X"
	tags="$tags,goes,goes-east,conus,america,north america,USA,meso,mesoscale"
	title="GOES-17 (West) Mesoscale 02 - $year/${month}/${day}"
	description="${description}\nUsing the red band images.\nA frame every 60 seconds"

elif [ "$1" = "gm1ir" ]; then
	type="goes_meso_01_ir"
	file=${year}${month}${day}_${type}.mp4
	playlist="PLnDVpcUXOcQahOWbg-o6U_7S7g4PAdv3b"
	tags="$tags,goes,goes-east,conus,america,north america,USA,meso,mesoscale,ir,infra,red,temperature"
	title="GOES-16 Mesoscale 01 Infra Red - $year/${month}/${day}"
	description="${description}\nBand 13 - 'Clean' IR Longwave Window\nA frame every 60 seconds"

elif [ "$1" = "gm2ir" ]; then
	type="goes_meso_02_ir"
	file=${year}${month}${day}_${type}.mp4
	playlist="PLnDVpcUXOcQaGKepljjQQjOPjiePo2FVu"
	tags="$tags,goes,goes-east,conus,america,north america,USA,meso,mesoscale,ir,infra,red,temperature"
	title="GOES-16 Mesoscale 02 Infra Red - $year/${month}/${day}"
	description="${description}\nBand 13 - 'Clean' IR Longwave Window\nA frame every 60 seconds"

elif [ "$1" = "hf" ]; then
	type="hima_full"
	file=${year}${month}${day}_himawari.mp4
	playlist="PLnDVpcUXOcQaPMx1nIv_lxPjRUg5p9DxA"
	tags="$tags,asia,japan,full disk,taiwan,australia,pacific,new zealand,china"
	title="Himawari-8 Full Disk - $year/${month}/${day}"
	description="${description}\nGeoColor Layer from http://www.cira.colostate.edu/ \nA frame every 10 minutes"
	
elif [ "$1" = "hj" ]; then
	type="hima_japan"
	file=${year}${month}${day}_himawari_japan.mp4
	playlist="PLnDVpcUXOcQYRIDlJqEwAAwKIdrfROuGH"
	tags="$tags,asia,japan,meso,mesoscale"
	title="Himawari-8 Japan - $year/${month}/${day}"
	description="${description}\nRed band imagery.\nA frame every 150 seconds"

elif [ "$1" = "hm" ]; then
	type="hima_meso_01"
	file=${year}${month}${day}_hima_mesoscale01.mp4
	playlist=""
	tags="$tags,asia,meso,mesoscale,typhoon"
	title="Himawari-8 Mesoscale - $year/${month}/${day}"
	description="${description}\nRed band imagery.\nA frame every 150 seconds\nJitter is from source images"

elif [ "$1" = "hm1ir" ]; then
	type="hima_meso_01_ir"
	file=${year}${month}${day}_hima_meso_01_ir.mp4
	playlist="PLnDVpcUXOcQYkP5h-kW8ElVjtp5sdjLAl"
	tags="$tags,asia,japan,taiwan,philippines,meso,mesoscale,ir,infra,red,temperature"
	title="Himawari-8 Mesoscale Infra Red - $year/${month}/${day}"
	description="${description}\nBand 13 - 'Clean' IR Longwave Window\nA frame every 150 seconds"

elif [ "$1" = "ht" ]; then
	type="hima_taiwan"
	file=${year}${month}${day}_himawari_taiwan.mp4
	playlist="PLnDVpcUXOcQb0fuDFJl8Hox3wzmm3NBHV"
	tags="$tags,asia,taiwan,korea,china,philippines,japan"
	title="Himawari-8 - $year/${month}/${day}"
	description="${description}\nGeoColor Layer from http://www.cira.colostate.edu/ \nA frame every 10 minutes"

elif [ "$1" = "tcwb" ]; then
	type="taiwan_cwb"
	file=${year}${month}${day}_radar.mp4
	playlist="PLnDVpcUXOcQaZ6nGRBcZbkLajE_GNqlr4"
	tags="$tags,taiwan,cwb,rainfall,formosa,himawari,satellite,taipei,tainan,kaohsiung,taichung,chiayi,hsinchu,keelung,yilan,hualien,taitung"
	title="Taiwan Weather - $year/${month}/${day}"
	description="Data scraped from https://www.cwb.gov.tw/eng/"
	
elif [ "$1" = "trcly" ]; then
	type="taiwan_radar"
	file=CV1_RCLY_1000_${year}${month}${day}.mp4
	tags="$tags,taiwan,cwb,rainfall,formosa,,taipei,tainan,kaohsiung,taichung,chiayi,hsinchu,keelung,yilan,hualien,taitung"
	title="Taiwan Radar - 高雄林園 Kaohsiung Linyuan (RCLY) - $year/${month}/${day}"
	description="Data scraped from https://www.cwb.gov.tw/V8/E/W/OBS_Radar_rain.html"

elif [ "$1" = "trcnt" ]; then
	type="taiwan_radar"
	file=CV1_RCNT_1000_${year}${month}${day}.mp4
	tags="$tags,taiwan,cwb,rainfall,formosa,,taipei,tainan,kaohsiung,taichung,chiayi,hsinchu,keelung,yilan,hualien,taitung"
	title="Taiwan Radar - 臺中南屯 Taichung Nantun (RCNT) - $year/${month}/${day}"
	description="Data scraped from https://www.cwb.gov.tw/V8/E/W/OBS_Radar_rain.html"

elif [ "$1" = "trcsl" ]; then
	type="taiwan_radar"
	file=CV1_RCSL_1000_${year}${month}${day}.mp4
	tags="$tags,taiwan,cwb,rainfall,formosa,,taipei,tainan,kaohsiung,taichung,chiayi,hsinchu,keelung,yilan,hualien,taitung"
	title="Taiwan Radar - 新北樹林 New Taipei Shulin (RCSL) - $year/${month}/${day}"
	description="Data scraped from https://www.cwb.gov.tw/V8/E/W/OBS_Radar_rain.html"
	
elif [ "$1" = "trext" ]; then
	type="taiwan_cwb"
	file=CV1_1000_${year}${month}${day}.mp4
	tags="$tags,taiwan,cwb,rainfall,formosa,,taipei,tainan,kaohsiung,taichung,chiayi,hsinchu,keelung,yilan,hualien,taitung"
	title="Taiwan Radar Extended Domain - $year/${month}/${day}"
	description="Data scraped from https://www.cwb.gov.tw/V8/E/W/OBS_Radar.html"

elif [ "$1" = "ukr" ]; then
	type="uk_rain"
	file=${year}${month}${day}_uk_rain.mp4
	playlist="PLnDVpcUXOcQYEzJ8ITR3YNJ1UnfPAP2cD"
	tags="uk,united kingdom,england,scotland,ireland,wales,rain,rainfall,radar,timelapse,britain,isles"
	title="UK Rain Radar - $year/${month}/${day}"
	description="Data scraped from https://www.netweather.tv/live-weather/radar \nBasemap is https://www.geofabrik.de/maps/rendering.html"

elif [ "$1" = "cairn" ]; then
	type="cairngorms"
	file=${year}${month}${day}_glenshee_lecht.mp4
	tags="uk,united kingdom,scotland,cairngorms,glenshee,highlands,lecht,braemar,spittal,strathdon,cairn,mount,B974,A93,rain,rainfall,snow,snowgate,snowfall,ski,snowboard"
	title="Glenshee / The Lecht / Snowgates - $year/${month}/${day}"
	description="Images scraped from:\n https://www.snowgatecameras.co.uk/ \n https://www.lecht.co.uk \n https://www.ski-glenshee.co.uk \n https://www.pkc.gov.uk/trafficcameras"
fi

if [ -f ${HOME}/${type}/${file} ]; then
	cd ${HOME}/${type}
	if [ ! -f x265_${file} ]; then
		toh265.sh ${file}
	fi

	cd ${HOME}
	#echo "{\"playlistIds\":[\"${playlist}\"],\
	echo "{\"description\":\"${description}\"}" > ${file}.json
#	echo "/--------------"
	./youtubeuploader_linux_amd64 \
			-quiet \
			-cache ${token} \
			-categoryId 28 \
			-filename ./${type}/x265_${file} \
			-limitBetween 05:00-23:30 \
			-privacy public \
			-ratelimit 400 \
			-tags "${tags}" \
			-title "${title}" \
			-metaJSON ${file}.json > ${type}/${file}.upload
#	echo "\-------------"
	echo
	rm ${file}.json
	rm ${type}/x265_${file}
fi
