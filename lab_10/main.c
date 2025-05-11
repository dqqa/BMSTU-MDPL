#include <stdio.h>
#include <time.h>

inline __attribute__((always_inline)) float sum_float(float a, float b)
{
    return a + b;
}

inline __attribute__((always_inline)) float mul_float(float a, float b)
{
    return a * b;
}

inline __attribute__((always_inline)) double sum_dbl(double a, double b)
{
    return a + b;
}

inline __attribute__((always_inline)) double mul_dbl(double a, double b)
{
    return a * b;
}

float sum_float_asm(float a, float b)
{
    float res;
    __asm__ volatile(
        "flds %1\n"
        "flds %2\n"
        "faddp\n"
        "fstps %0\n"
        : "=m"(res)
        : "m"(a), "m"(b));
    return res;
}

double sum_dbl_asm(double a, double b)
{
    double res;
    __asm__ volatile(
        "fldl %1\n"
        "fldl %2\n"
        "faddp\n"
        "fstpl %0\n"
        : "=m"(res)
        : "m"(a), "m"(b));
    return res;
}

float mul_float_asm(float a, float b)
{
    float res;
    __asm__ volatile(
        "flds %1\n"
        "flds %2\n"
        "fmulp\n"
        "fstps %0\n"
        : "=m"(res)
        : "m"(a), "m"(b));
    return res;
}

double mul_dbl_asm(double a, double b)
{
    double res;
    __asm__ volatile(
        "fldl %1\n"
        "fldl %2\n"
        "fmulp\n"
        "fstpl %0\n"
        : "=m"(res)
        : "m"(a), "m"(b));
    return res;
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
        // volatile float res = sum_float(i, i);
        // volatile double res = sum_dbl(i, i);
        // volatile float res = mul_float(i, i);
        // volatile double res = mul_dbl(i, i);

        // volatile float res = sum_float_asm(i, i);
        // volatile float res = mul_float_asm(i, i);
        // volatile double res = sum_dbl_asm(i, i);
        volatile double res = mul_dbl_asm(i, i);
        (void)res;
    }
    cur_time(&end);

    printf("Nsec avg: %f\n", (end - start) / ITER_COUNT);

    return 0;
}
