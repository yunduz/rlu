#!/bin/bash

# if [ $# -lt 1 ]; then
#     echo "Not enough arguments passed $#."
# else
#     echo "Running $1"
# fi

for updates in 20 #200 400
do
	current_time=$(date "+%Y.%m.%d-%H.%M.%S")

	for num_threads in 1 2 #4 6 8 10 12 14 16 18 20 22 24
	do
		for j in 1 2 3
		do
			echo ./bench-lock -a -b1000 -d10000 -i100000 -r200000 -w1 -u$updates -n$num_threads
			./bench-lock -a -b1000 -d10000 -i100000 -r200000 -w1 -u$updates -n$num_threads 2>> logs/lock_hashlst_u${updates}_${current_time}_error.log 1>> logs/lock_hashlst_u${updates}_${current_time}_output.log
	   		#./$1 $i 2>> $1_error.log 1>> $1_output.log
	   	done
	done
done

# ./bench-rlu -a -b1 -d1000 -i256 -r512 -w1 -u20 -n4