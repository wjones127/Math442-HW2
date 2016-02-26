#include <stdio.h>
#include <stdlib.h>

int32_t run_04h(int32_t lvl_idx){
    union cpuid_eax{
        uint32_t val; 
        struct {
            uint32_t cache_type:5;
            uint32_t cache_lvl:3;
            uint32_t si:1;
            uint32_t assoc:1;
            uint32_t rest:22;
            } bits;
    };

    union cpuid_ebx{
        uint32_t val; 
        struct {
            uint32_t line_size:12;
            uint32_t line_parts:10;
            uint32_t ways_assoc:10;
            } bits;
    };

    const int32_t cpuid_code = 4;
    int32_t ecx = -1;
    int32_t edx = -1;
    union cpuid_eax eax;
    union cpuid_ebx ebx;


    __asm__(
        "movl %[code], %%eax\n\t"
        "movl %[lvl], %%ecx\n\t"
        "cpuid\n\t"
        "movl %%eax, %[out_eax]\n\t"
        "movl %%ebx, %[out_ebx]\n\t"
        "movl %%ecx, %[out_ecx]\n\t"
        "movl %%edx, %[out_edx]\n\t"
        :[out_eax] "=r" (eax), [out_ebx] "=r" (ebx), [out_ecx] "=r" (ecx), [out_edx] "=r" (edx) 
        :[code] "r" (cpuid_code), [lvl] "r" (lvl_idx)
        :"eax", "ebx", "ecx", "edx"//clobbered, as indicated in manual
        );
    
    printf("results for code %d: \n\teax: %d, \n\tebx: %d, \n\tecx: %d, \n\tedx: %d\n", lvl_idx, eax.val, ebx.val, ecx, edx);

    printf("\n\tresults for EAX");
    printf("\n\tEAX: %d", eax.val);
    printf("\n\t\tCache Type:  %d\n\t\tCache Level:  %d",  eax.bits.cache_type, eax.bits.cache_lvl);
    printf("\n\t\tSelf initializing cache: %d \n\t\tFully associative: %d", eax.bits.si, eax.bits.assoc);

    printf("\n\tEBX: %d", ebx.val);
    printf("\n\t\tLine Size: %d\n\t\tLine Partitions: %d", ebx.bits.line_size+1, ebx.bits.line_parts+1);
    printf("\n\t\tWays of associativity: %d\n", ebx.bits.ways_assoc+1);
    return eax.val;
}

int main() 
{ 
    int32_t i = 0;
    int32_t res = 0;
    do{ 
        res = run_04h(i);
        i++;
    } while (res);
    exit(EXIT_SUCCESS);
}
