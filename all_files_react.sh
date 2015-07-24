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

SNIFFER_HOST="172.22.16.57"
SNIFFER_PATH="/home/rkapoor/Projects/dcsw/feng_sniffer/pfc_tcp/snf_tcpdump_fpga"
SNIFFER_PATH_0="/home/rkapoor/netslice/snf_simple_tcpdump -b 0"
RESULTS_DIR="/home/rkapoor/react_results/"
sniffer_1=" -b 1"
#sniffer_0=" -b 0 -f test_packet_switch"


files=( 750m  75m 25m 100m 250m 500m 1g 5g 10g)
files=( 750 25 100 75 5000 250 500 1000 )
files=( 25 750 25 100 75 250 500 1000 )
#files=( 750 25 100 75 250 500 1000 )
#files=( 5g 25m 1g 75m 100m 5g 250m 500m 5g 750m  )
files=(500)
exps=(hadoop)
clients=(1)
repeats=(2 3)
#blocksizes=(16 32 64 128 256 512 1024)
blocksizes=(128 256 512 1024)
blocksizes=(128 256 512 1024)
blocksizes=(512)
readaheads=(64 128 192 256 512)
readaheads=(384 640 768 896 1024)
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
            #base="new_tests_intel_mqon_repeat_queue_0__${readahead}_read_${blocksize}_"
            base="intel_mqoff_${readahead}_read_${blocksize}_"
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
                        pssh_wrapper.sh dcsw:react "rm /mnt/localdisks/*.img"
                        pssh_wrapper.sh dcsw:react "cd /mnt/localdisks/; rm *.img"
                        pssh_wrapper.sh dcsw:react "echo 3 | sudo tee /proc/sys/vm/drop_caches"

                        ssh $SNIFFER_HOST "${SNIFFER_PATH} ${sniffer_1}" &
                        mkdir -p ${RESULTS_DIR}/${dir}

                        #ssh ${SNIFFER_HOST} "~/netslice/sniffer/./snf_simple_tcpdump -b 0 -f hadoop_${file}" | tee /tmp/sniffer_output &
                        ssh ${SNIFFER_HOST} "cp ~/${nic}_tag ${RESULTS_DIR}/${dir}/tags" 
                        ssh ${SNIFFER_HOST} "echo \"exp=${exp}\" >> ${RESULTS_DIRS}/${dir}/tags" 
                        ssh ${SNIFFER_HOST} "echo \"readahead=${readahead}\" >> ${RESULTS_DIRS}/${dir}/tags" 
                        ssh ${SNIFFER_HOST} "echo \"readsize=${blocksize}\" >> ${RESULTS_DIRS}/${dir}/tags" 
                        ssh ${SNIFFER_HOST} "echo \"client=${client}\" >> ${RESULTS_DIRS}/${dir}/tags" 
                        ssh ${SNIFFER_HOST} "echo \"disk=${raid}\" >> ${RESULTS_DIRS}/${dir}/tags" 
                        if [ "$exp" == "java" ]
                        then
                            ssh 172.22.16.55 "pkill -f 'java MultiThreadedServer'"
                            ssh 172.22.16.55 "cd /home/rkapoor/sockets/java; java " \
                                " MultiThreadedServer $client" &
                            sleep 2
                        fi
                        ./run_exp_${exp}.sh $file $client
                        ssh 172.22.16.55 "pkill -f 'java MultiThreadedServer'"
                        echo "finished server"
                        #ssh ${SNIFFER_HOST} "killall snf_simple_tcpdump"
                        ssh $SNIFFER_HOST "killall snf_tcpdump_fpga"
                        mv /home/rkapoor/fpga_pkt_trace* ${RESULTS_DIR}/${dir}/
                        echo "killed sniffer"
                        pssh_wrapper.sh dcsw:react "echo 3 | sudo tee /proc/sys/vm/drop_caches"
                        sleep 5
                        #bytes_sent=`grep  "Total bytes received,  app:" /tmp/sniffer_output | awk {'print $5'}`
                        #let "expected_bytes=client*file*1024*1024"
                        #echo ${bytes_sent}, ${expected_bytes}
                        #diff=`echo "(100.0*(${bytes_sent} -${expected_bytes}))/${expected_bytes}" | bc -l`
                        #echo $diff
                        #diff=`echo "($diff+0.5)/1" | bc`
                        #echo $diff
                        #if [ $diff -gt 20 ] || [ $diff -lt  0 ]
                        #then
                        #    echo "Error: Check experiment", ${bytes_sent}, ${expected_bytes}
                        #ssh SNIFFER_HOST "echo \"error=true\" >> ${RESULTS_DIRS}/${dir}/tags" 
                        #fi
                        wait
                    done
                done
            done
        done
    done
done
