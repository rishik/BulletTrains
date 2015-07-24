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
rsize=$1
echo $rsize
HOST="172.22.16.55"
ssh $HOST "echo $rsize | sudo tee /sys/block/sda/queue/read_ahead_kb"
ssh $HOST "echo $rsize | sudo tee /sys/block/sdb/queue/read_ahead_kb"
ssh $HOST "echo $rsize | sudo tee /sys/block/sdd/queue/read_ahead_kb"
ssh $HOST "echo $rsize | sudo tee /sys/block/sde/queue/read_ahead_kb"
ssh $HOST "echo $rsize | sudo tee /sys/block/sdf/queue/read_ahead_kb"
ssh $HOST "echo $rsize | sudo tee /sys/block/sdg/queue/read_ahead_kb"
ssh $HOST "echo $rsize | sudo tee /sys/block/sdh/queue/read_ahead_kb"
ssh $HOST "echo $rsize | sudo tee /sys/block/sdi/queue/read_ahead_kb"
ssh $HOST "echo $rsize | sudo tee /sys/block/sdj/queue/read_ahead_kb"
ssh $HOST "echo $rsize | sudo tee /sys/block/sdk/queue/read_ahead_kb"
echo "updated read ahead value"
echo $rsize | sudo tee /sys/block/sda/queue/read_ahead_kb
echo $rsize | sudo tee /sys/block/sdb/queue/read_ahead_kb
echo $rsize | sudo tee /sys/block/sdd/queue/read_ahead_kb
echo $rsize | sudo tee /sys/block/sde/queue/read_ahead_kb
echo $rsize | sudo tee /sys/block/sdf/queue/read_ahead_kb
echo $rsize | sudo tee /sys/block/sdg/queue/read_ahead_kb
echo $rsize | sudo tee /sys/block/sdh/queue/read_ahead_kb
echo $rsize | sudo tee /sys/block/sdi/queue/read_ahead_kb
echo $rsize | sudo tee /sys/block/sdj/queue/read_ahead_kb
echo $rsize | sudo tee /sys/block/sdk/queue/read_ahead_kb
#ssh $HOST "cat /sys/block/sdb/queue/read_ahead_kb"
ssh $HOST "cat /sys/block/sdd/queue/read_ahead_kb"
