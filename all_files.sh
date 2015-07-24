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
files=( 750m  75m 25m 100m 250m 500m 1g 5g 10g)
files=( 750 25 100 75 5000 250 500 1000 )
files=( 25 750 25 100 75 250 500 1000 )
files=(500 1000)
exps=(nfs)
clients=(1 4)
repeats=(1 2)
#blocksizes=(16 32 64 128 256 512 1024)
#blocksizes=(512 128  1024)
blocksizes=(128 256 512 1024)
blocksizes=(1024)
readaheads=(128)
nic="intel"
raid="raid"
for readahead in "${readaheads[@]}"
do
    echo "Read ahead  "$reaadahead
    ./setup_readahead.sh ${readahead}
    for exp in "${exps[@]}"
    do
        if [ "$exp" == "hadoop" ]
        then
            blocksizes=("default")
        fi
        if [ "$exp" == "java" ]
        then
            blocksizes=("default")
        fi
        for blocksize in "${blocksizes[@]}"
        do
            base="new_tests_intel_mqon_repeat_queue_0__${readahead}_read_${blocksize}_"
            echo $blocksize
            for repeat in "${repeats[@]}"
            do
                ${exp}_experiment/./setup_${exp}.sh ${blocksize}
                sleep 10
                for client  in "${clients[@]}"
                do
                    for file in "${files[@]}"
                    do
                        echo $repeat $exp $client $file
                        sync
                        #                /home/rkapoor/Projects/dcsw/disk/./eatram 23750
                        dir=${base}${exp}"_"${client}"_"${repeat}
                        echo $dir
                        ssh 172.22.16.76 "mkdir /mnt/disks/${dir}"
                        pssh_wrapper.sh dcsw "rm /mnt/localdisks/*.img"
                        pssh_wrapper.sh dcsw "cd /mnt/localdisks/; rm *.img"
                        pssh_wrapper.sh dcsw "echo 3 | sudo tee /proc/sys/vm/drop_caches"
                        ssh 172.22.16.76 "cd /mnt/disks/${dir};~/netslice/sniffer/./snf_simple_tcpdump -b 0 -f hadoop_${file}" | tee /tmp/sniffer_output &
                        ssh 172.22.16.76 "cp ~/${nic}_tag /mnt/disks/${dir}/tags" 
                        ssh 172.22.16.76 "echo \"exp=${exp}\" >> /mnt/disks/${dir}/tags" 
                        ssh 172.22.16.76 "echo \"readahead=${readahead}\" >> /mnt/disks/${dir}/tags" 
                        ssh 172.22.16.76 "echo \"readsize=${blocksize}\" >> /mnt/disks/${dir}/tags" 
                        ssh 172.22.16.76 "echo \"client=${client}\" >> /mnt/disks/${dir}/tags" 
                        ssh 172.22.16.76 "echo \"disk=${raid}\" >> /mnt/disks/${dir}/tags" 
                        if [ "$exp" == "java" ]
                        then
                            ssh 172.22.16.63 "pkill -f 'java MultiThreadedServer'"
                            ssh 172.22.16.63 "cd /home/rkapoor/sockets/java; java " \
                                " MultiThreadedServer $client" &
                            sleep 2
                        fi
                        ./run_exp_${exp}.sh $file $client
                        ssh 172.22.16.63 "pkill -f 'java MultiThreadedServer'"
                        echo "finished server"
                        ssh 172.22.16.76 "killall snf_simple_tcpdump"
                        echo "killed sniffer"
                        pssh_wrapper.sh dcsw "echo 3 | sudo tee /proc/sys/vm/drop_caches"
                        sleep 5
                        bytes_sent=`grep  "Total bytes received,  app:" /tmp/sniffer_output | awk {'print $5'}`
                        let "expected_bytes=client*file*1024*1024"
                        echo ${bytes_sent}, ${expected_bytes}
                        diff=`echo "(100.0*(${bytes_sent} -${expected_bytes}))/${expected_bytes}" | bc -l`
                        echo $diff
                        diff=`echo "($diff+0.5)/1" | bc`
                        echo $diff
                        if [ $diff -gt 20 ] || [ $diff -lt  0 ]
                        then
                            echo "Error: Check experiment", ${bytes_sent}, ${expected_bytes}
                        ssh 172.22.16.76 "echo \"error=true\" >> /mnt/disks/${dir}/tags" 
                        fi
                        wait
                    done
                done
            done
        done
    done
done
