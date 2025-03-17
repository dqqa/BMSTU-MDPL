format ELF64

ROWS equ 9
COLS equ 9

STDIN_FILENO equ 0
STDOUT_FILENO equ 1

SYS_exit equ 60
SYS_write equ 1
SYS_read equ 0

macro exit code
{
    mov rax, SYS_exit
    mov rdi, code
    syscall
}

extrn printf
extrn scanf

section '.text' executable

; entry start
start:
    call main
    exit 0

public main
main:
    push rbp
    mov rbp, rsp

    ; mov rdi, STDOUT_FILENO
    ; mov rsi, msg
    ; mov edx, msg_len
    ; mov rax, SYS_write
    ; syscall

    ; mov rdi, input_cnt_fmt
    ; call input_number

    ; mov rdi, input_rows_cnt
    ; call input_number

    ; mov rdi, input_cols_cnt
    ; call input_number

    mov rdi, matrix
    mov esi, 2
    mov edx, 2
    call input_matrix

    xor rax, rax

    mov rsp, rbp
    pop rbp
    ret

; rdi - mat ptr
; rsi - row idx
calc_row_sum:
    push rbp
    mov rbp, rsp
    sub rsp, 16

    xor rax, rax
    mov rax, COLS
    mul rsi

    add rdi, rax

    mov qword [rbp-8], 0 ; sum
    xor rcx, rcx

.again:
    mov al, byte [rdi+rcx]
    add qword [rbp-8], rax

    inc rcx
    cmp rcx, COLS
    je .end

.end:
    mov rax, qword [rbp-8]
    mov rsp, rbp
    pop rbp
    ret

; rdi - msg
input_number:
    push rbp
    mov rbp, rsp
    sub rsp, 16

    mov esi, dword [rbp-4]
    call PLT printf

    mov rdi, input_cnt_fmt
    lea rsi, [rbp-4]
    call PLT scanf

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
    sub rsp, 16

    mov eax, esi
    mul edx
    mov dword [rbp-4], eax ; count
    mov qword [rbp-12], rdi ; saved mat ptr

    mov rdi, input_matrix_msg
    call PLT printf

    mov dword [rbp-16], 0 ; counter

.input_loop:
    xor rax, rax
    mov eax, dword [rbp-4]
    cmp dword [rbp-16], eax
    je .ok

    mov rdi, input_element_fmt
    mov rsi, qword [rbp-12]

    xor rax, rax
    mov eax, dword [rbp-16]
    add rsi, rax

    call PLT scanf
    cmp rax, 1
    jne .error

    inc dword [rbp-16]
    jmp .input_loop

.error:
    mov rdi, panic_msg
    call PLT printf
    exit 1

.ok:
    mov rsp, rbp
    pop rbp
    ret


section '.rodata'
input_rows_cnt db "Input row count: ", 0
input_cols_cnt db "Input col count: ", 0
input_matrix_msg db "Input matrix: ", 0
input_cnt_fmt db "%d", 0

input_element_fmt db "%hhd", 0

panic_msg db "Panic!", 10, 0

section '.bss' writable
matrix db ROWS*COLS dup (0xff)
