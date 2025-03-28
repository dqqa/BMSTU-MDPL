#include <stdint.h>
#include <stdio.h>

int main(void)
{
    int16_t num = 0xfff0;
    char c = (char)num;
    printf("%hd %hhx\n", num, c);
    return 0;
}
