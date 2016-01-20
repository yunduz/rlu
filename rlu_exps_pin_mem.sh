#!/bin/bash

#///////////////////////////////////
# LINKED LIST
#////////////////////////////////////
# pin threads to cores
#///////////////////////////////////

# rlu
for write_sets in 1 10
do
	for updates in 20 200 400
	do
		current_time=$(date "+%Y.%m.%d-%H.%M.%S")

		# for num_threads in 1 2 4 6 8 10 12 14 16 18 20 22 23
		for num_threads in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23
		do
			for j in 1 2 3
			do
				echo likwid-pin -q -c M0:0-5@M1:0-5@M2:0-5@M3:0-5 ./bench-rlu -a -b1 -d10000 -i1000 -r2000 -w$write_sets -u$updates -n$num_threads
				likwid-pin -q -c M0:0-5@M1:0-5@M2:0-5@M3:0-5 ./bench-rlu -a -b1 -d10000 -i1000 -r2000 -w$write_sets -u$updates -n$num_threads 2>> logs/pin_rlu_ws${write_sets}_u${updates}_${current_time}_error.log 1>> logs/pin_rlu_ws${write_sets}_u${updates}_${current_time}_output.log
		   	done
		done
	done
done

# lock
for updates in 20 200 400
do
	current_time=$(date "+%Y.%m.%d-%H.%M.%S")

	#for num_threads in 1 2 4 6 8 10 12 14 16 18 20 22 23
	for num_threads in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23
	do
		for j in 1 2 3
		do
			echo likwid-pin -q -c M0:0-5@M1:0-5@M2:0-5@M3:0-5 ./bench-lock -a -b1 -d10000 -i1000 -r2000 -w1 -u$updates -n$num_threads
			likwid-pin -q -c M0:0-5@M1:0-5@M2:0-5@M3:0-5 ./bench-lock -a -b1 -d10000 -i1000 -r2000 -w1 -u$updates -n$num_threads 2>> logs/pin_lock_u${updates}_${current_time}_error.log 1>> logs/pin_lock_u${updates}_${current_time}_output.log
	   	done
	done
done



#///////////////////////////////////
# LINKED LIST
#/////////////////////////////////////////
# pin threads to cores + interleave memory
#////////////////////////////////////////

# rlu
for write_sets in 1 10
do
	for updates in 20 200 400
	do
		current_time=$(date "+%Y.%m.%d-%H.%M.%S")

		# for num_threads in 1 2 4 6 8 10 12 14 16 18 20 22 23
		for num_threads in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23
		do
			for j in 1 2 3
			do
				echo likwid-pin -i -q -c M0:0-5@M1:0-5@M2:0-5@M3:0-5 ./bench-rlu -a -b1 -d10000 -i1000 -r2000 -w$write_sets -u$updates -n$num_threads
				likwid-pin -i -q -c M0:0-5@M1:0-5@M2:0-5@M3:0-5 ./bench-rlu -a -b1 -d10000 -i1000 -r2000 -w$write_sets -u$updates -n$num_threads 2>> logs/pin_i_rlu_ws${write_sets}_u${updates}_${current_time}_error.log 1>> logs/pin_i_rlu_ws${write_sets}_u${updates}_${current_time}_output.log
		   	done
		done
	done
done

# lock
for updates in 20 200 400
do
	current_time=$(date "+%Y.%m.%d-%H.%M.%S")

	#for num_threads in 1 2 4 6 8 10 12 14 16 18 20 22 23
	for num_threads in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23
	do
		for j in 1 2 3
		do
			echo likwid-pin -i -q -c M0:0-5@M1:0-5@M2:0-5@M3:0-5 ./bench-lock -a -b1 -d10000 -i1000 -r2000 -w1 -u$updates -n$num_threads
			likwid-pin -i -q -c M0:0-5@M1:0-5@M2:0-5@M3:0-5 ./bench-lock -a -b1 -d10000 -i1000 -r2000 -w1 -u$updates -n$num_threads 2>> logs/pin_i_lock_u${updates}_${current_time}_error.log 1>> logs/pin_i_lock_u${updates}_${current_time}_output.log
	   	done
	done
done

#///////////////////////////////////
# HASH LIST
#////////////////////////////////////
# pin threads to cores
#///////////////////////////////////

# rlu
for write_sets in 1 10
do
	for updates in 20 200 400
	do
		current_time=$(date "+%Y.%m.%d-%H.%M.%S")

		#for num_threads in 1 2 4 6 8 10 12 14 16 18 20 22 23
		for num_threads in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23
		do
			for j in 1 2 3
			do
				echo likwid-pin -q -c M0:0-5@M1:0-5@M2:0-5@M3:0-5 ./bench-rlu -a -b1000 -d10000 -i100000 -r200000 -w$write_sets -u$updates -n$num_threads
				likwid-pin -q -c M0:0-5@M1:0-5@M2:0-5@M3:0-5 ./bench-rlu -a -b1000 -d10000 -i100000 -r200000 -w$write_sets -u$updates -n$num_threads 2>> logs/pin_rlu_hashlst_ws${write_sets}_u${updates}_${current_time}_error.log 1>> logs/pin_rlu_hashlst_ws${write_sets}_u${updates}_${current_time}_output.log
		   	done
		done
	done
done

# lock
for updates in 20 200 400
do
	current_time=$(date "+%Y.%m.%d-%H.%M.%S")

	#for num_threads in 1 2 4 6 8 10 12 14 16 18 20 22 23
	for num_threads in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23
	do
		for j in 1 2 3
		do
			echo likwid-pin -q -c M0:0-5@M1:0-5@M2:0-5@M3:0-5 ./bench-lock -a -b1000 -d10000 -i100000 -r200000 -w1 -u$updates -n$num_threads
			likwid-pin -q -c M0:0-5@M1:0-5@M2:0-5@M3:0-5 ./bench-lock -a -b1000 -d10000 -i100000 -r200000 -w1 -u$updates -n$num_threads 2>> logs/pin_lock_hashlst_u${updates}_${current_time}_error.log 1>> logs/pin_lock_hashlst_u${updates}_${current_time}_output.log
	   	done
	done
done

#///////////////////////////////////
# HASH LIST
#/////////////////////////////////////////
# pin threads to cores + interleave memory
#////////////////////////////////////////

# rlu
for write_sets in 1 10
do
	for updates in 20 200 400
	do
		current_time=$(date "+%Y.%m.%d-%H.%M.%S")

		#for num_threads in 1 2 4 6 8 10 12 14 16 18 20 22 23
		for num_threads in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23
		do
			for j in 1 2 3
			do
				echo likwid-pin -i -q -c M0:0-5@M1:0-5@M2:0-5@M3:0-5 ./bench-rlu -a -b1000 -d10000 -i100000 -r200000 -w$write_sets -u$updates -n$num_threads
				likwid-pin -i -q -c M0:0-5@M1:0-5@M2:0-5@M3:0-5 ./bench-rlu -a -b1000 -d10000 -i100000 -r200000 -w$write_sets -u$updates -n$num_threads 2>> logs/pin_i_rlu_hashlst_ws${write_sets}_u${updates}_${current_time}_error.log 1>> logs/pin_i_rlu_hashlst_ws${write_sets}_u${updates}_${current_time}_output.log
		   	done
		done
	done
done

# lock
for updates in 20 200 400
do
	current_time=$(date "+%Y.%m.%d-%H.%M.%S")

	#for num_threads in 1 2 4 6 8 10 12 14 16 18 20 22 23
	for num_threads in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23
	do
		for j in 1 2 3
		do
			echo likwid-pin -i -q -c M0:0-5@M1:0-5@M2:0-5@M3:0-5 ./bench-lock -a -b1000 -d10000 -i100000 -r200000 -w1 -u$updates -n$num_threads
			likwid-pin -i -q -c M0:0-5@M1:0-5@M2:0-5@M3:0-5 ./bench-lock -a -b1000 -d10000 -i100000 -r200000 -w1 -u$updates -n$num_threads 2>> logs/pin_i_lock_hashlst_u${updates}_${current_time}_error.log 1>> logs/pin_i_lock_hashlst_u${updates}_${current_time}_output.log
	   	done
	done
done