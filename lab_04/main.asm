format ELF64

include "common.inc"

public panic_msg

extrn input_number
extrn input_matrix
extrn print_matrix
extrn remove_max_row

section '.text' executable

public main
main:
    push rbp
    mov rbp, rsp
    sub rsp, 16

    lea rdi, [input_rows_cnt]
    call input_number
    mov dword [rbp-4], eax ; row count

    lea rdi, [input_cols_cnt]
    call input_number
    mov dword [rbp-8], eax ; column count

    lea rdi, [matrix]
    mov esi, dword [rbp-4]
    mov edx, dword [rbp-8]
    call input_matrix

    lea rdi, [matrix]
    lea rsi, [rbp-4]
    mov edx, dword [rbp-8]
    call remove_max_row

    lea rdi, [result_msg]
    call printf

    lea rdi, [matrix]
    mov esi, dword [rbp-4]
    mov edx, dword [rbp-8]
    call print_matrix

    xor rax, rax

    mov rsp, rbp
    pop rbp
    ret

section '.rodata'
input_rows_cnt db "Input row count: ", 0
input_cols_cnt db "Input col count: ", 0

panic_msg db "Panic!", 10, 0

result_msg db "Result:", 10, 0

section '.bss' writable
matrix db ROWS*COLS dup (?)

section '.note.GNU-stack'
