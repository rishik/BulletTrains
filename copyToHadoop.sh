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
array=(1280)
test=( 1 2 3 4 5 6 7 8)
array=(1000)

for file in "${array[@]}"
do
for index in "${test[@]}"
do
    copy_file="/mnt/disks/${file}_${index}.img"
    echo $copy_file
    bin/hadoop fs -copyFromLocal $copy_file /user/.
done
done
