# Part 1
# random_sample: random_sample.c
# 	gcc -o0 random_sample.c -o random_sample

CFLAGS= -Wall -Werror -Wextra -Wpedantic -o3 -g

sample_sequential: src/sample_sequential.c
	gcc src/sample_sequential.c $(CFLAGS) -o build/sample_sequential

sample_random: src/sample_random.c
	gcc src/sample_random.c src/getRealTime.c $(CFLAGS) -o build/sample_random

test_sequential: build/sample_sequential
	benchmarks/test_sequential.sh > data/test_sequential.csv
	Rscript plots/sequential_plot.R

test_random: build/sample_random
	benchmarks/test_random.sh > data/test_random.csv
	Rscript plots/random_plots.R

# Part 2
