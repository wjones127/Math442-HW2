#!/bin/bash
echo "index, byte, size, time_ns"

# Loop over size
for (( k = 2**8; k <= 2**30; k *= 2))
do
    # ./random_sample $k 10
    ./sample_sequential $k 10
done

