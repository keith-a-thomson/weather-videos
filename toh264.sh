for file in "$@"
do
	echo "Encoding ${file} in toh264.sh"
	ffmpeg.exe -hide_banner -nostats -loglevel warning -y -i $file \
		-c:v libx264 \
		-movflags +faststart \
		-level 4.0 -bf 2 -g 12 -coder 1 -crf 16 -pix_fmt yuv420p \
		x264_$file
done
