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
ssh 172.22.16.63 "echo 3 | sudo tee /proc/sys/vm/drop_caches"
sleep 2
ssh 172.22.16.65 "~/sockets/broadcast-cond/broadcast_listen \"/home/rkapoor/software/hadoop-1.0.4/bin/hadoop fs -get hdfs://192.168.5.63:54310/user/${file}_1.img /mnt/localdisks/${file} \"" &

ssh 172.22.16.81 "~/sockets/broadcast-cond/broadcast_listen \"/home/rkapoor/software/hadoop-1.0.4/bin/hadoop fs -get hdfs://192.168.5.63:54310/user/${file}_2.img /mnt/localdisks/${file} \"" &

ssh 172.22.16.66 "~/sockets/broadcast-cond/broadcast_listen \"/home/rkapoor/software/hadoop-1.0.4/bin/hadoop fs -get hdfs://192.168.5.63:54310/user/${file}_3.img /mnt/localdisks/${file} \"" &
ssh 172.22.16.68 "~/sockets/broadcast-cond/broadcast_listen \"/home/rkapoor/software/hadoop-1.0.4/bin/hadoop fs -get hdfs://192.168.5.63:54310/user/${file}_4.img /mnt/localdisks/${file} \"" &
sleep 5
echo "test" | nc 192.168.5.255 4950 -u -b &
echo "test" | nc 192.168.5.255 4950 -u -b &
sleep 2
echo "test" | nc 192.168.5.255 4950 -u -b &

killall nc
wait
