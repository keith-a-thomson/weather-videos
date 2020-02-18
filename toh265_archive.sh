for file in "$@"
do
        ffmpeg.exe -y -i $file -c:v libx265 -crf 25 x265_crf25_$file
done
