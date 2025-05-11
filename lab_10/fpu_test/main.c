#include <stdio.h>
#include <math.h>

#define EPS 1e-4
#define TOL 1e-4

double f(double x)
{
    return sin(x * x + 5 * x + 0.1);
}

double bisection_method(double a, double b, int max_iters)
{
    int i = 0;
    while (i < max_iters)
    {
        double c = (a + b) / 2;
        if (fabs(f(c)) < EPS || (b - a) / 2 < TOL)
            return c;

        ++i;
        int sig_c = f(c) < 0 ? -1 : 1;
        int sig_a = f(a) < 0 ? -1 : 1;

        if (sig_c == sig_a)
            a = c;
        else
            b = c;
    }

    printf("Unable to find root!\n");
    return 0;
}

int main(void)
{
    printf("Result: %f\n", bisection_method(1.47, 1.82, 100));

    return 0;
}
