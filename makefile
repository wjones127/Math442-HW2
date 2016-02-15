# Part 1
# random_sample: random_sample.c
# 	gcc -o0 random_sample.c -o random_sample

sample_sequential: sample_sequential.c
	gcc sample_sequential.c -Wall -Werror -Wextra -pedantic -O3 -g -o sample_sequential

sample_random: sample_random.c
	gcc sample_random.c -Wall -Werror -Wextra -pedantic -O3 -g -o sample_random

test_sequential: sample_sequential
	./benchmark.sh > test_sequential.csv
	Rscript make_plots.R

test_random: sample_random
	./benchmark_random.sh > test_random.csv
	Rscript make_plots.R

# Part 2
