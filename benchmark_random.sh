#!/bin/bash
echo "index, byte, size, time_ns"

# Loop over size
for (( k = 2**8; k <= 2**30; k *= 2))
do
    ./sample_random $k 100000 10
done

