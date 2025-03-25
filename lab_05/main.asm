default rel

global main

extern printf
extern scanf
extern input_hexadecimal
extern print_unsigned_binary

section .text
main:
    push rbp
    mov rbp, rsp
    sub rsp, 16

    lea rdi, [msg]
    call input_hexadecimal

    mov word [rbp-2], ax

    mov rsi, rax
    mov rdx, rax
    lea rdi, [print_msg]
    call printf wrt ..plt
    
    lea rdi, [bin_print_msg]
    call printf wrt ..plt

    mov di, word [rbp-2]
    call print_unsigned_binary

    xor rax, rax

    mov rsp, rbp
    pop rbp
    ret

section .rodata
msg db "Input number: ", 0
print_msg db `You entered: \`%d\` (0x%hx)\n`, 0
bin_print_msg db `Binary: `, 0

section .note.GNU-stack
