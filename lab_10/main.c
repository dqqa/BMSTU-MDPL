#include <stdio.h>
#include <time.h>

inline float __attribute__((always_inline)) sum_float(float a, float b)
{
    return a + b;
}

inline float __attribute__((always_inline)) mul_float(float a, float b)
{
    return a * b;
}

inline double __attribute__((always_inline)) sum_dbl(double a, double b)
{
    return a + b;
}

inline double __attribute__((always_inline)) mul_dbl(double a, double b)
{
    return a * b;
}

inline __attribute__((always_inline)) unsigned long long tick()
{
    unsigned int a, b;
    __asm__ __volatile__(
        "rdtsc\n"
        : "=a"(a), "=d"(b));

    return ((unsigned long long)b << 32) | a;
}

static inline __attribute__((always_inline)) void cur_time(double *time)
{
    struct timespec cur;
    clock_gettime(CLOCK_MONOTONIC_RAW, &cur);

    *time = cur.tv_sec * 1e9 + cur.tv_nsec;
}

#define ITER_COUNT 10000000

int main(void)
{
    double start, end;
    cur_time(&start);
    for (size_t i = 0; i < ITER_COUNT; ++i)
    {
        volatile float res = sum_float(i, i);
        (void)res;
        // volatile double res = sum_dbl(i, i);
        // volatile float res = mul_float(i, i);
        // volatile double res = mul_dbl(i, i);
    }
    cur_time(&end);

    printf("Nsec avg: %f\n", (end-start) / ITER_COUNT);

    return 0;
}
