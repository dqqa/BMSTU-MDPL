#include <stdio.h>

int square(int num)
{
    return num * num;
}

int mult2(int num)
{
    return num * 2;
}

int (*table[])(int) = {
    square,
    mult2
};

int main(void)
{
    int idx;
    scanf("%d", &idx);
    printf("%d\n", table[idx](123));
    return 0;
}
