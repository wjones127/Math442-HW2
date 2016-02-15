#!/bin/bash
echo "size, time_ns, num"

# Loop over size
for (( k = 256; k <= 2**16; k *= 2))
do
    ./random_sample $k 10
done

