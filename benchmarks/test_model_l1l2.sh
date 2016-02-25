#!/bin/bash
echo "size, bucket_size, time_ns, checksum"

# ------------------------------------------------------------------------------
# PROBLEM AND BUCKET SIZE TEST
# ------------------------------------------------------------------------------
# To detect caches, we will do better by varing both the problem size and bucket
# size, allowing us to have a larger dimensional space with which we could detect
# the cache sizes and even the cache latencies.

# Loop over size
for (( k = 2**12; k <= 2**17; k *= 2))
do
    # Loop over num buckets
    for (( i = 100; i <= 5000; i += 200))
    do
        build/sample_random $k 100000 $i
    done
done
