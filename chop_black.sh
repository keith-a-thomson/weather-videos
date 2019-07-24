read -r start end <<<$(ffmpeg.exe -i $1  -vf "blackdetect=d=2:pix_th=0.10" -an -f null - 2>&1 | grep blackdetect | sed 's/.*black_start:\(.*\) black_end:\(.*\) black_duration.*/\1 \2/')
#echo black start-$start
#echo black end-$end
start_real=`echo $start 1 | awk '{print $1 + $2}'`
end_real=`echo $end 1 | awk '{print $1 - $2}'`
#echo ${start_real}
#echo ${end_real}
fname=${1%.*}
ffmpeg.exe -hide_banner -nostats -ss 0 -to ${start_real} -i $1 -vcodec libx265 -crf 0 -pix_fmt yuv420p -preset slow ${fname}_p1.mp4
ffmpeg.exe -hide_banner -nostats -ss ${end_real} -i $1 -vcodec libx265 -crf 0 -pix_fmt yuv420p -preset slow ${fname}_p2.mp4

