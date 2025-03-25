default rel

global main

extern printf
extern scanf

extern panic
extern input_hexadecimal
extern print_unsigned_binary
extern print_signed_decimal
extern print_max_power_of_2

NUM_OF_ENTRIES equ 4

section .text
main:
    push rbp
    mov rbp, rsp
    sub rsp, 16

    lea rdi, [msg]
    call input_hexadecimal

    mov word [rbp-2], ax

.loop_begin:
    lea rdi, [menu]
    call printf wrt ..plt

    lea rdi, [menu_opt_scan_fmt]
    lea rsi, [rbp-6]
    call scanf wrt ..plt
    
    test rax, rax
    jne .ok
    call panic

.ok:
    cmp dword [rbp-6], 0
    jg .ok1
    call panic

.ok1:
    cmp dword [rbp-6], NUM_OF_ENTRIES
    jle .ok2
    call panic

.ok2:
    cmp dword [rbp-6], NUM_OF_ENTRIES
    je .loop_end

    dec dword [rbp-6]
    mov eax, dword [rbp-6]
    mov bx, 8
    mul bx

    mov rbx, rax
    lea rax, [rel ptr_table]

    add rax, rbx
    mov di, word [rbp-2]

    call [rax]
    ; mov rsi, rax
    ; mov rdx, rax
    ; lea rdi, [print_msg]
    ; call printf wrt ..plt
    
    ; lea rdi, [bin_print_msg]
    ; call printf wrt ..plt

    ; mov di, word [rbp-2]
    ; call print_unsigned_binary

    ; lea rdi, [stripped_print_msg]
    ; call printf wrt ..plt

    ; mov di, word [rbp-2]
    ; call print_signed_decimal

    ; mov di, word [rbp-2]
    ; call print_max_power_of_2

    lea rdi, [newline]
    call printf wrt ..plt

    jmp .loop_begin

.loop_end:
    xor rax, rax

    mov rsp, rbp
    pop rbp
    ret

section .rodata
msg db "Input number: ", 0

menu db \
`Menu:\n \
1. Convert to unsigned in 2 num. system.\n \
2. Print signed decimal stripped (8 bit).\n \
3. Max power of 2 (num % (2**power) == 0)\n \
4. Exit\n\
Enter option: `, 0
menu_opt_scan_fmt db "%d", 0

print_msg db `You entered: \`%d\` (0x%hx)\n`, 0
bin_print_msg db `Binary: `, 0
stripped_print_msg db `Stripped signed decimal: `, 0
newline db 10, 0

section .data.rel
ptr_table dq print_unsigned_binary, \
            print_signed_decimal, \
            print_max_power_of_2

section .note.GNU-stack
