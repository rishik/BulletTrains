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
base="/mnt/disks2/"
hostlist=(172.22.16.65 172.22.16.66 172.22.16.68 172.22.16.81 172.22.16.107 \
          172.22.16.108 172.22.16.109 172.22.16.110)
totalhosts=${#hostlist[@]}
echo $totalhosts
count=0
ssh 172.22.16.63 "echo 3 | sudo tee /proc/sys/vm/drop_caches"
for host in "${hostlist[@]:0:${hosts}}"
do
    let "count =count + 1"
    echo $host
    exec="java Client"

    ssh $host "$exec ${base}${file}_${count}.img" &
done

wait
