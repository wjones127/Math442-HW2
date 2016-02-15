# Part 1
random_sample: random_sample.c
	gcc -o0 random_sample.c -o random_sample

test1: random_sample
	./benchmark.sh > test1.csv
	Rscript make_plots.R

# Part 2
