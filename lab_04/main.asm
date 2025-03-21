format ELF64

include "common.inc"

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

    ;       |  16  ||   8    ||   8    |
    ; 0 ... [locals][prev_rbp][ret_addr] ... 0xff..ff
    ; RSP:  ^

    ; Stack 16-byte aligned (x86_64 System V ABI)
    ; Args via registers: rdi, rsi, rdx, rcx, r8, r9
    ; Return via rax

    lea rdi, [input_rows_cnt] ; RIP-relative addressing
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

    cmp dword [rbp-4], 0
    je .empty

    lea rdi, [matrix]
    mov esi, dword [rbp-4]
    mov edx, dword [rbp-8]
    call print_matrix
    jmp .end

.empty:
    lea rdi, [empty_msg]
    call printf

.end:
    xor rax, rax

    mov rsp, rbp
    pop rbp
    ret

section '.rodata'
input_rows_cnt db "Input row count: ", 0
input_cols_cnt db "Input col count: ", 0

result_msg db "Result:", 10, 0
empty_msg db "Empty matrix", 10, 0

section '.bss' writable
matrix db ROWS*COLS dup (?)

; т.к. подразумеваем что стек не будет иметь права на выполнение
section '.note.GNU-stack'
