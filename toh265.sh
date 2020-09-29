for file in "$@"
do
        ffmpeg -hide_banner -nostats -loglevel warning -y -i $file -c:v libx265 -crf 22  -preset faster x265_$file
done
