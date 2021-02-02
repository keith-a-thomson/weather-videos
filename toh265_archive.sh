for file in "$@"
do
        ffmpeg.exe -y -i $file -c:v libx265 -crf 28 x265_crf28_$file
done
