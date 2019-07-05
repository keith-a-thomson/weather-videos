for file in "$@"
do
        ffmpeg.exe -y -i $file -c:v libx265 -crf 16 x265_crf16_$file
done
