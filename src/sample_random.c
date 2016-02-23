#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <inttypes.h>
#include "getRealTime.h"
#include "random.h"

void go(uint32_t size, uint32_t iter, uint32_t buckets) 
{
    uint32_t seed = getRealTime();
    srand(seed); 

    uint32_t bucket_size = (int)iter/buckets;
    uint32_t *rand_index =  generate_random_ints(bucket_size, size);
  
    uint8_t *byte_array = generate_random_bytes(size);
    for(uint32_t i = 0; i < buckets; i ++){
        uint32_t chksum = 0;
        //generate an array w/ random indices

        // if (i%bucket_size == 0){
        free(rand_index);
        seed = getRealTime();
        srand(seed); 
        rand_index = generate_random_ints(bucket_size, size);
        // } 

        double start = getRealTime();
        for (uint32_t j = 0; j < bucket_size; j++){
            uint8_t b = byte_array[rand_index[j]];
            chksum += b;
        }
        // uint64_t start = current_time();
        double end = getRealTime();  
        double mean_time = (end-start)/(double)bucket_size;
        printf("%u, %u, %f, %u\n", size, bucket_size, mean_time, chksum);
        // Print
    }
    free(byte_array);
}


int main(int argc, char **argv) 
{
    assert(argc == 4 && "require two arguments to run");

    uint32_t size = strtol(argv[1], NULL, 0);
    uint32_t iter = strtol(argv[2], NULL, 0);
    uint32_t buckets = strtol(argv[3], NULL, 0);
    // uint32_t useASM = strtol(argv[3], NULL, 0);

    assert(iter > 0 && size > 0 && buckets > 0 && "iter and size must be positive");
    // assert((useASM == 0 || useASM == 1) && "Use asm should be either true or false");

    go(size, iter, buckets);
}
