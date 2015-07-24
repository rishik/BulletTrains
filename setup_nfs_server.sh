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
sudo mkdir -p /export/users
sudo mount --bind /mnt/disk /export/users

# was working for conext-2013
sudo echo "/mnt/disks" \
          "192.168.1.0/24(rw,nohide,insecure,no_subtree_check,async)" \
          > /etc/exports
sudo echo "/mnt/disks" \
          "172.22.16.0/24(rw,sync,no_subtree_check,no_root_squash)" \
          > /etc/exports


sudo service nfs-kernel-server restart
