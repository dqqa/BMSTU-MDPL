default rel

global print_unsigned_binary

extern printf

section .text
; di - number
print_unsigned_binary:
    push rbp
    mov rbp, rsp
    sub rsp, 16

    mov word [rbp-2], 15 ; bit counter
    mov word [rbp-4], di ; saved number

    lea rdi, [bin_print_msg]
    call printf wrt ..plt

.loop:
    cmp word [rbp-2], 0
    jl .endloop
    mov ax, 1
    mov cx, word [rbp-2]
    shl ax, cl ; ax - bit mask

    mov bx, word [rbp-4]
    test bx, ax
    je .zero
    mov rsi, 1
    jmp .print_bit

.zero:
    xor rsi, rsi

.print_bit:
    lea rdi, [bit_output_fmt]
    call printf wrt ..plt

    dec word [rbp-2]
    jmp .loop

.endloop:
    lea rdi, [newline]
    call printf wrt ..plt

    xor rax, rax

    mov rsp, rbp
    pop rbp
    ret

section .rodata
bit_output_fmt db `%u`, 0
bin_print_msg db `Binary: `, 0

newline db 10, 0

section .note.GNU-stack
