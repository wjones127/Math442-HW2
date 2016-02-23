#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include "random.h"

float random_float (int32_t lower_bound, int32_t upper_bound) 
{
    float scale = upper_bound - lower_bound;
    return ((rand() / (float) RAND_MAX) * scale) + lower_bound;
}

uint32_t random_int (int32_t lower_bound, int32_t upper_bound) 
{
    return lower_bound + rand() % (upper_bound-lower_bound);
}

uint8_t random_byte()
{
    return rand()%256;
}

uint32_t * generate_random_ints(size_t array_size, uint32_t bound) 
{
    uint32_t *arr = calloc(array_size, sizeof(uint32_t *));
    for (uint32_t i = 0; i < array_size; i++) {
        arr[i] = random_int(0, bound);
    }
    return arr;
}

uint8_t * generate_random_bytes(size_t array_size) 
{
    uint8_t *arr = calloc(array_size, sizeof(uint8_t *));
    for (uint32_t i = 0; i < array_size; i++) {
        arr[i] = random_byte();
    }
    return arr;
}
