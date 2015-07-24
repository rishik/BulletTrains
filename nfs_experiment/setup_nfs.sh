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
readahead=$2
let "rsize=rsize*1024"
echo $rsize
HOST="192.168.5.55"
proj=dcsw:react7
pssh_wrapper.sh dcsw:react7 "sudo umount /mnt/disks"
sleep 5
pssh_wrapper.sh dcsw:react7 "sudo sudo mount -t nfs -o " \
"proto=tcp,port=2049,rsize=${rsize} $HOST:/mnt/disks /mnt/disks -v"
