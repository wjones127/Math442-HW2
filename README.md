# Math 442 HW2: Benchmarking the Memory Hierarchy

This is a collaboration between Will Jones (wjones127) and Isabella Jorissen (ifjorissen).

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

Does this hold up for different sizes? It seems to differ in success for small sizes (around 4096 bytes) and
large sizes (larger than 2MB). That upper bound may simply be due to running out of room in a higher level cache,
possibly the L3 cache. Here we have the minimum access time by inverse bucket size for several array sizes.

![Minimum access time by bucket size and array size.](https://raw.githubusercontent.com/wjones127/Math442-HW2/master/plots/out/model_confirm.png)

It seems for smaller and larger array sizes, only large bucket sizes behave normally.

We do a linear regression for each of these sizes, taking the intercept as a computed access time
without interruptions. Below we plot the results of this computation.

![Computed access time versus array size.](https://github.com/wjones127/Math442-HW2/blob/master/plots/out/computed_times.png)

The blue lines show the sizes of the L1, L2, and L3 caches, as specified by [the website EveryMac](http://www.everymac.com/systems/apple/macbook-air/specs/macbook-air-core-i5-1.8-13-mid-2012-specs.html).

There doesn't seem to be very clear patterns here. The first dip might correspond to the transition to the L2 cache, but that is
hard to see. The second dip looks like it's just around the size where the linear relationship between measured access time and inverse bucket size seems to fail.


### Notes

This is really difficult to measure in a way that gets us a really clear
drop-off in performance. The more iterations in a bucket, the more misses will
just be smoothed out. But with fewer iterations in a bucket, we just end up
measuring the time it takes to get the time.
