default rel

global my_strcpy

section .text

; char *my_strcpy(char *dst, const char *src, size_t size);
my_strcpy:
    push rbp
    mov rbp, rsp
    sub rsp, 16

    mov qword [rbp-8], rdi ; saved dest ptr
    mov qword [rbp-16], rdx
    mov rcx, rdx ; size

    mov rax, rdi
    cmp rdi, rsi
    je .end
    jb .fwd

    mov rax, rsi
    add rax, rcx
    cmp rdi, rax
    jae .fwd

    std
    lea rsi, [rsi+rcx-1]
    lea rdi, [rdi+rcx-1]
    rep movsb
    cld

    add rdi, qword [rbp-16]
    inc rdi
    mov byte [rdi], 0 ; Терминирующий '\0'
    jmp .end

.fwd:
    rep movsb
    mov byte [rdi], 0 ; Терминирующий '\0'

.end:
    mov rax, qword [rbp-8]

    mov rsp, rbp
    pop rbp
    ret

section .rodata

section .note.GNU-stack
