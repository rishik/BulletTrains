#!/bin/bash
file=$1
copies=(1 2 3 4 5 6 7 8)
for copy in "${copies[@]}"
do
    dd if=/dev/zero of=/mnt/disks/${file}_${copy}.img bs=1M count=$((file))
sync
done
