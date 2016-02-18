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

The overhead of measuring time can mean that we are mostly measuring the amount
of time to compute current time, rather than time to access. At the same time,
simply taking one average per array size could not give us an accurate sense of
the variance. So we will try bucketing the computations; e.g. measure the time
to access `k` different random bytes in the array.



### Notes

This is really difficult to measure in a way that gets us a really clear
drop-off in performance. The more iterations in a bucket, the more misses will
just be smoothed out. But with fewer iterations in a bucket, we just end up
measuring the time it takes to get the time.
