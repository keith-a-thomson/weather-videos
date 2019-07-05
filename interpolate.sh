imagecount=$1
imageidx=$2
imageone=$3
imagetwo=$4
itwo=$imageidx
ione=$((imagecount+1-imageidx))

margs=""
for ((a=1; a<=ione; a++)); do
	margs="$margs $imageone"
done
for ((b=1; b<=itwo; b++)); do
	margs="$margs $imagetwo"
done

echo $margs
