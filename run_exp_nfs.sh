#!/usr/bin/env bash
#
# Copyright (c) 2012, Regents of the University of California
# All rights reserved.
#
#
# Last updated:
#
# Author(s): Rishi Kapoor (rkapoor@cs.ucsd.edu)
#
# Desciption:

# vim: ts=4 sw=4 expantab:
file=$1
hosts=$2
totalhosts=${#hostlist[@]}
echo $totalhosts
count=0
HOST="172.22.16.55"
ssh $HOST "echo 3 | sudo tee /proc/sys/vm/drop_caches"
hostlist=(172.22.16.54 172.22.16.51 172.22.16.52 172.22.16.53 172.22.16.50 \
          172.22.16.56)
for host in "${hostlist[@]:0:${hosts}}"
do
    let "count =count + 1"
    echo $host
    ssh $host "~/sockets/broadcast-cond/broadcast_listen \"cp \
        /mnt/disks/${file}_${count}.img /mnt/localdisks/. \"" &
done
sleep 10
echo "test" | nc 192.168.5.255 4950 -u -b &
echo "test" | nc 192.168.5.255 4950 -u -b &
sleep 2
killall nc
killall nc
killall nc
echo "waitinng for transfer to finish"
wait
echo "job finished"
