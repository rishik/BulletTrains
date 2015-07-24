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
ssh 172.22.16.66 "time cp /mnt/disks/${file}.img /mnt/localdisks/." &
ssh 172.22.16.81 "time cp /mnt/disks/${file}_2.img /mnt/localdisks/." &
time cp /mnt/disks/${file}_1.img /mnt/localdisks/. &
wait
