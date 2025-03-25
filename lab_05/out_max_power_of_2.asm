default rel

global print_max_power_of_2

extern printf

section .text
; di - number
print_max_power_of_2:
    push rbp
    mov rbp, rsp
    sub rsp, 16

    mov word [rbp-2], 15

.loop_begin:
    cmp word [rbp-2], 0
    jl .loop_end
    mov ax, di
    
    mov cx, word [rbp-2]
    mov bx, 1
    shl bx, cl
    
    xor dx, dx
    div bx
    test dx, dx
    je .loop_end

    dec word [rbp-2]
    jmp .loop_begin

.loop_end:
    lea rdi, [message]
    mov si, word [rbp-2]
    call printf wrt ..plt

    mov rsp, rbp
    pop rbp
    ret

section .rodata
message db `Max power of 2: %hu\n`, 0

section .note.GNU-stack
