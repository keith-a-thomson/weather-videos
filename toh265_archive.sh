for file in "$@"
do
        ffmpeg.exe -y -i $file -c:v libx265 -crf 20 x265_crf20_$file
done
