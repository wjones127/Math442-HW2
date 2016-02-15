#!/bin/bash
echo "index, byte, time_ns"

# Loop over size
for (( k = 256; k <= 2**16; k *= 2))
do
    ./random_sample $k 10
done

