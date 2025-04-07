default rel

global my_strcpy

section .text

; char *my_strcpy(char *dst, const char *src, size_t size);
my_strcpy:
    push rbp
    mov rbp, rsp
    sub rsp, 16

    mov qword [rbp-8], rdi

    mov rcx, rdx ; size
    rep movsb

    mov byte [rdi], 0 ; Терминирующий '\0'

    mov rax, qword [rbp-8]

    mov rsp, rbp
    pop rbp
    ret

section .rodata

section .note.GNU-stack
