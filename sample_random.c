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

uint32_t random_int (int32_t lower_bound, int32_t upper_bound) 
{
    return lower_bound + rand() % (upper_bound-lower_bound);
}

uint8_t random_byte(){
    return rand()%256;
}

uint8_t * generate_random_bytes(size_t array_size) 
{
    uint8_t *arr = calloc(array_size, sizeof(uint8_t *));
    for (uint32_t i = 0; i < array_size; i++) {
        arr[i] = random_byte();
    }
    return arr;
}

void go(uint32_t size, uint32_t iter) 
{
    uint32_t seed = current_time();
    srand(seed); 
  
    uint8_t *byte_array = generate_random_bytes(size);
    for(uint32_t i = 0; i < iter; i ++){
        // Start time
        uint32_t rand_index =  random_int(0, size);
        uint64_t start = current_time();
        uint8_t b = byte_array[rand_index];
        uint64_t end = current_time();  
        printf("%u, %hhu, %u, %llu\n", rand_index, b, size, end - start);
        // Print
    }
    free(byte_array);
}


int main(int argc, char **argv) 
{
    assert(argc == 3 && "require two arguments to run");

    uint32_t size = strtol(argv[1], NULL, 0);
    uint32_t iter = strtol(argv[2], NULL, 0);
    // uint32_t useASM = strtol(argv[3], NULL, 0);

    assert(iter > 0 && size > 0 && "iter and size must be positive");
    // assert((useASM == 0 || useASM == 1) && "Use asm should be either true or false");

    go(size, iter);
}
