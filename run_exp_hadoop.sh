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
hostlist=(172.22.16.65 172.22.16.66 172.22.16.68 172.22.16.81 172.22.16.107 \
          172.22.16.108 172.22.16.109 172.22.16.110)
hostlist=(172.22.16.50 172.22.16.51 172.22.16.52 172.22.16.53 172.22.16.54 \
          172.22.16.56 172.22.16.57)
totalhosts=${#hostlist[@]}
echo $totalhosts
count=0
ssh 172.22.16.55 "echo 3 | sudo tee /proc/sys/vm/drop_caches"
for host in "${hostlist[@]:0:${hosts}}"
do
    let "count =count + 1"
    echo $host
    ssh $host "export _JAVA_OPTIONS=\"-Xmx4g\" ;~/sockets/broadcast-cond/broadcast_listen" \
        "\"/home/rkapoor/software/hadoop-1.0.4/bin/hadoop " \
        " fs -get hdfs://192.168.5.55:54310/user/${file}_${count}.img" \
        "/mnt/localdisks/${file}.img \"" &
done

sleep 5
echo "test" | nc 192.168.5.255 4950 -u -b &
echo "test" | nc 192.168.5.255 4950 -u -b &
echo "test" | nc 192.168.5.255 4950 -u -b &

killall nc
sleep 5
echo "test" | nc 192.168.5.255 4950 -u -b &
killall nc
killall nc
wait
