#include <stdio.h>
#include <string.h>

#ifdef __x86_64__
#define PLATFORM "x86_64 version (64-bit)\n\n"
#else
#define PLATFORM "x86 version (32-bit)\n\n"
#endif

size_t __attribute__((naked)) my_strlen(const char *str)
{
    __asm__ __volatile__(
        "pushq %rbp\n"
        "movq %rsp, %rbp\n"
        "subq $16, %rsp\n"

        "movq %rdi, -8(%rbp)\n"
        "xor %rcx, %rcx\n"
        "notq %rcx\n"
        "xorb %al, %al\n"
        "repne scasb\n"

        "subq -8(%rbp), %rdi\n"
        "decq %rdi\n"
        "movq %rdi, %rax\n"

        "movq %rbp, %rsp\n"
        "popq %rbp\n"
        "ret\n");
}

char *my_strcpy(char *dst, const char *src, size_t size);

int main(void)
{
    printf(PLATFORM);

    const char *str = "qwerty";
    size_t len = my_strlen(str);

    printf("len(`%s`) = %zu\n", str, len);

    char buf[128];
    memset(buf, 'a', sizeof(buf)); // Проверим, что терминирующий нуль выставляется

    my_strcpy(buf, "abcdefghi", 9);
    printf("Non-overlapping buf: `%s`\n", buf);

    strcpy(buf, "qwertyuiop");
    my_strcpy(buf, buf + 1, my_strlen(buf) - 1); // Две строки накладываются друг на друга
    printf("Overlapping buf: `%s`\n", buf);

    return 0;
}
