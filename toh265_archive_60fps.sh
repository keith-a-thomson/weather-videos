for file in "$@"
do
        ffmpeg.exe -y -i $file  -r 60 -filter:v "setpts=0.4*PTS" -c:v libx265 -crf 16 x265_crf16_$file
done
