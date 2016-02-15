#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <inttypes.h>


#ifdef __MACH__
#include <mach/clock.h>
#include <mach/mach.h>
#endif

#define BILLION  1E9

/*
 * Used the following function to get time for Mac OS X.
 * Based on this snippet: https://gist.github.com/alfwatt/3588c5aa1f7a1ef7a3bb
 */

int current_utc_time(struct timespec *ts) 
{
#ifdef __MACH__ // OS X does not have clock_gettime, use clock_get_time
    clock_serv_t cclock;
    mach_timespec_t mts;
    host_get_clock_service(mach_host_self(), CALENDAR_CLOCK, &cclock);
    clock_get_time(cclock, &mts);
    mach_port_deallocate(mach_task_self(), cclock);
    ts->tv_sec = mts.tv_sec;
    ts->tv_nsec = mts.tv_nsec;
    return 0;
#else
    return clock_gettime(CLOCK_REALTIME, ts);
#endif
}

uint64_t current_time()
{
    /* returns time in milliseconds */
    struct timespec tp;
    int res = current_utc_time(&tp); 
    if (res == -1) {
        fprintf(stderr, "Failure with clock_gettime");
        return 0;
    }
    return BILLION * tp.tv_sec + tp.tv_nsec;
}

float random_float (int32_t lower_bound, int32_t upper_bound) 
{
    float scale = upper_bound - lower_bound;
    return ((rand() / (float) RAND_MAX) * scale) + lower_bound;
}

float* generate_random_array (size_t array_size, int32_t bound) 
{
    float *arr = calloc(array_size, sizeof(float));
    assert(arr && "give us memory");
    for (uint32_t i = 0; i < array_size; i++) {
        arr[i] = random_float(-1 * bound, bound);
    }
    return arr;
}

void combine_arrays_float(float *a, float *b, uint64_t size) 
{
    // performs a[i] += b[i] for i = 0 to size
    uint64_t o = 0;
    asm (
        "movq %3, %%rdx\n" // size 
        "movq $0, %%rcx\n" // counter

        // main part of loop. performs +=
        "loop_start4:\n"
        "movss (%1, %%rcx, 4), %%xmm0\n"
        "movss (%2, %%rcx, 4), %%xmm1\n"
        "addss %%xmm0, %%xmm1\n"
        "movss %%xmm1, (%1, %%rcx, 4)\n"
        "incq %%rcx\n"

        // loop condition
        "cmpq %%rdx, %%rcx\n"
        "jl loop_start4\n"

        "movq $0, %0\n"
        :"=r"(o)
        :"r"(a), "r"(b), "r"(size)
        :"%xmm0","xmm1","%rcx","%rdx"         /* clobbered register */
        );
    assert(o == 0 && "assembly failed\n");
}

void update_coords_asm(float *x, float *y, float *z, float *vx, float *vy,
                   float *vz, size_t size) 
{
    combine_arrays_float(x, vx, size);
    combine_arrays_float(y, vy, size);
    combine_arrays_float(z, vz, size);
}

void update_coords(float *x, float *y, float *z, float *vx, float *vy,
                   float *vz, size_t size) 
{
    for (uint32_t i = 0; i < size; i++) {
        x[i] += vx[i];
        y[i] += vy[i];
        z[i] += vz[i];
  }
}

float sum(float *arr, size_t size) 
{
    float sum = 0;
    for (uint32_t i = 0; i < size; i++)
        sum += arr[i];
    return sum;
}

void go(uint32_t size, uint32_t iter, uint32_t useASM) 
{
    printf("%d,%d,", size, iter);
    srand(size); 
  
    float *x = generate_random_array(size, 1000);
    float *y = generate_random_array(size, 1000);
    float *z = generate_random_array(size, 1000);
    float *vx = generate_random_array(size, 1);
    float *vy = generate_random_array(size, 1);
    float *vz = generate_random_array(size, 1);

    uint64_t start = current_time();
    if (useASM) {
        for (uint32_t i = 0; i < iter; i++) {
            update_coords_asm(x, y, z, vx, vy, vz, size);
        }
    } else {
        for (uint32_t i = 0; i < iter; i++) {
            update_coords(x, y, z, vx, vy, vz, size);
        }
    }
    uint64_t end = current_time();
    printf("%lu,", end - start);

    // checksum is an invariant of the input parameters (size and iter)
    float chksum = sum(x, size) + sum(y, size) + sum(z, size);
    printf("%.6f\n", chksum);
 
    free(x); 
    free(y); 
    free(z); 
    free(vx);
    free(vy);
    free(vz);
}


int main(int argc, char **argv) 
{
    assert(argc == 4 && "require two arguments to run");

    uint32_t size = strtol(argv[1], NULL, 0);
    uint32_t iter = strtol(argv[2], NULL, 0);
    uint32_t useASM = strtol(argv[3], NULL, 0);

    assert(iter > 0 && size > 0 && "iter and size must be positive");
    assert((useASM == 0 || useASM == 1) && "Use asm should be either true or false");

    go(size, iter, useASM);
}
