#!/bin/bash
echo "size, bucket_size, time_ns, checksum"

# -----------------------------------------------------------------------------#
# BIN SIZE TEST
# -----------------------------------------------------------------------------#
# Because it's near impossible to get enough time granularity to measure one
# memory access, we bin memory accesses when timing them and compute the average
# time. Here we want to understand how binsize affects time, so we can determine
# what kind of overhead there is timewise, and what will be the optimum binsize
# to test with.

# Loop over number of bins, keeping
for (( k = 20; k <= 10000; k *= 2))
do
    build/sample_random 256 100000 $k
done
