default rel

global input_hexadecimal

extern panic
extern scanf
extern printf

section .text
; rdi -> ptr to prompt
input_hexadecimal:
    push rbp
    mov rbp, rsp
    sub rsp, 16

    call printf wrt ..plt

    lea rdi, [num_input_fmt]
    lea rsi, [rbp-2]
    call scanf wrt ..plt

    test rax, rax
    jne .ok
    call panic

.ok:
    mov ax, [rbp-2]

    mov rsp, rbp
    pop rbp
    ret

section .rodata
num_input_fmt db "%hx", 0 ; 16 bit number

section .note.GNU-stack
