# Math 442 HW2: Benchmarking the Memory Hierarchy

From the assignment:

> The main goal of this exercise is to empirically determine the sizes of the
> different cache layers in a processor by building a micro-benchmark that
> measures memory performance for different request sizes.

## Part 1: Reading one byte from N-size buffer

Our first goal is the test the latency of reading one byte from a buffer of
size `N`, where we are varying `N`. Our approach will be to initialize an array
of random numbers, and then run a loop where we generate a random index and
measure the time it takes to access the index.
