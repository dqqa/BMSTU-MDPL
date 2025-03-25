default rel

global panic

extern printf
extern exit

section .text
panic:
    push rbp
    mov rbp, rsp
    sub rsp, 16

    lea rdi, [panic_msg]
    call printf wrt ..plt

    call exit wrt ..plt

section .rodata
panic_msg db `Panic!\n`, 0

section .note.GNU-stack
