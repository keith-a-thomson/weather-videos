for file in "$@"
do
        ffmpeg.exe -y -i $file -c:v libx265 x265_$file
done
