format ELF64

include "common.inc"

public input_number
public input_matrix
public print_matrix

section '.text' executable

; rdi - msg
input_number:
    push rbp
    mov rbp, rsp
    sub rsp, 16

    mov esi, dword [rbp-4]
    call printf

    lea rdi, [input_cnt_fmt]
    lea rsi, [rbp-4]
    call scanf
    cmp rax, 1
    jne .error
    jmp .ok

.error:
    lea rdi, [panic_msg]
    call printf
    exit 1

.ok:
    mov eax, dword [rbp-4]

    mov rsp, rbp
    pop rbp
    ret

; rdi - mat ptr
; esi - rows cnt
; edx - cols cnt
input_matrix:
    push rbp
    mov rbp, rsp
    sub rsp, 32

    mov qword [rbp-8], rdi ; saved mat ptr

    mov dword [rbp-28], esi ; row count
    mov dword [rbp-32], edx ; col count

    lea rdi, [input_matrix_msg]
    call printf

    mov dword [rbp-16], 0 ; row counter
    mov dword [rbp-24], 0 ; col counter

.row_loop:
    xor rax, rax
    mov eax, dword [rbp-16]
    cmp dword [rbp-28], eax
    je .ok

.col_loop:
    xor rax, rax
    mov eax, dword [rbp-24]
    cmp dword [rbp-32], eax
    je .col_end

    lea rdi, [input_element_fmt]
    xor rax, rax
    mov eax, dword [rbp-16]
    mov rbx, COLS
    mul rbx
    add eax, dword [rbp-24]
    mov rsi, qword [rbp-8]
    add rsi, rax

    call scanf
    cmp rax, 1
    jne .error

    inc dword [rbp-24]
    jmp .col_loop

.col_end:
    mov dword [rbp-24], 0
    inc dword [rbp-16]
    jmp .row_loop

.error:
    lea rdi, [panic_msg]
    call printf
    exit 1

.ok:
    mov rsp, rbp
    pop rbp
    ret

; rdi - mat ptr
; rsi - row count
; rdx - column count
print_matrix:
    push rbp
    mov rbp, rsp
    sub rsp, 48

    mov qword [rbp-8], 0  ; row counter
    mov qword [rbp-16], 0 ; column counter

    and esi, 0xffffffff
    and edx, 0xffffffff
    mov qword [rbp-24], rsi ; rows
    mov qword [rbp-32], rdx ; columns

    mov qword [rbp-40], rdi ; saved mat ptr

.row_loop:
    mov rax, qword [rbp-24]
    cmp rax, qword [rbp-8]
    je .end
.col_loop:
    mov rax, qword [rbp-32]
    cmp rax, qword [rbp-16]
    je .col_end

    mov rsi, qword [rbp-40]
    mov rax, qword [rbp-8]
    mov rbx, COLS
    mul rbx

    add rsi, rax
    add rsi, qword [rbp-16]
    mov sil, byte [rsi]

    lea rdi, [print_element_fmt]
    call printf

    inc qword [rbp-16]
    jmp .col_loop

.col_end:
    lea rdi, [newline]
    call printf

    mov qword [rbp-16], 0 ; обнуляем счетчик столбцов
    inc qword [rbp-8] ; увеличиваем счетчик строк
    jmp .row_loop

.end:
    mov rsp, rbp
    pop rbp
    ret

section '.rodata'
input_cnt_fmt db "%d", 0
input_element_fmt db "%hhd", 0
input_matrix_msg db "Input matrix", 10, 0

print_element_fmt db "%hhd ", 0
panic_msg db "Panic!", 10, 0

newline db 10, 0

section '.note.GNU-stack'
