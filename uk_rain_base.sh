mkdir -p ~/uk_rain
cd ~/uk_rain

#base_url=https://b.tile.openstreetmap.org/
#base_name=osm

#base_url=https://tile.geofabrik.de/15173cf79060ee4a66573954f6017ab0/
#base_name=osm_geofab

#base_url=https://b.tile.opentopomap.org/
#base_name=osm_topo

base_url=https://b.tile.thunderforest.com/transport/
base_name=trans

# Background image
mkdir -p ${base_name}
cd ${base_name}
curl ${base_url}8/[118-133]/[74-89].png?apikey=7c352c8ff1244dd8b732e349e0b0fe8d -o "#2_#1.png"
magick.exe montage *.png -geometry +0+0 -tile 16x ../${base_name}.png
cd ..

