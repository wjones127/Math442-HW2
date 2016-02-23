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


### Measuring Bin Size

Let's start by looking at measuring latency for just one size. We should assume
that there is some amount of time taken to record the start and end times, which
we will denote `timer.start` and `timer.end`, respectively. In addition, there is
some non-negative amount of time `interruption` taken up by interruptions by other
programs. We measure `T`, the total number of nanoseconds for the bucket of size
`N` to complete divided by `N`. We want to find `t`, the number of
nanoseconds per memory access. We might assume the relationship,

```
T = 1 / N (timer.start + t * N + timer.end + interruption)
```
which can be expressed as
```
T = t + (timer.start + timer.end + interruption) * (1/N)
```

Does this relationship seem to hold? We measured `T` for different `N`, with
the array size at 256 (small enough to fit in a modern L1 cache).

![Average Random Access Latency by Bucket Size](https://github.com/wjones127/Math442-HW2/raw/master/plots/out/binsize.png)
![Average Random Access Latency by Inverse Bucket Size](https://github.com/wjones127/Math442-HW2/raw/master/plots/out/inv_binsize.png)

The trends here seem pretty clear when looking at the minimum averages. All the
points above those seem reasonably attributable to interruptions by other
processes. The nice things about the second form is that we can get an
approximate measurement of `t` without any overhead, by simply finding the
intercept of a line fitted to the minimum values. (Actually, a best fit line
is pretty close to this, if we are willing to add a few tens of a nanosecond to
our measurement, which is more likely the latency we should expect in practice
anyways.)


### Notes

This is really difficult to measure in a way that gets us a really clear
drop-off in performance. The more iterations in a bucket, the more misses will
just be smoothed out. But with fewer iterations in a bucket, we just end up
measuring the time it takes to get the time.
