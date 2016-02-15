#!/bin/bash
echo "size, bucket_size, time_ns checksum"

# Loop over size
for (( k = 2**8; k <= (2**32 -1); k *= 2))
do
    ./sample_random $k 100000 10
done

