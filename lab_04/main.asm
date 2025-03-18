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

extrn 'printf' as _printf
printf = PLT _printf

extrn 'scanf' as _scanf
scanf = PLT _scanf

extrn 'memmove' as _memmove
memmove = PLT _memmove

section '.text' executable

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

    lea rdi, [matrix]
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
    call printf

    lea rdi, [input_cnt_fmt]
    lea rsi, [rbp-4]
    call scanf

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

    lea rdi, [input_matrix_msg]
    call printf

    mov dword [rbp-16], 0 ; counter

.input_loop:
    xor rax, rax
    mov eax, dword [rbp-4]
    cmp dword [rbp-16], eax
    je .ok

    lea rdi, [input_element_fmt]
    mov rsi, qword [rbp-12]

    xor rax, rax
    mov eax, dword [rbp-16]
    add rsi, rax

    call scanf
    cmp rax, 1
    jne .error

    inc dword [rbp-16]
    jmp .input_loop

.error:
    lea rdi, [panic_msg]
    call printf
    exit 1

.ok:
    mov rsp, rbp
    pop rbp
    ret

; rdi - mat ptr
; esi - row index
; edx - row count
; ecx - columns count
delete_matrix_row:
    push rbp
    mov rbp, rsp
    sub rsp, 16

    and ecx, 0xFFFFFFFF

    mov rax, rcx
    mul esi

    add rdi, rax ; сместились до строки

    push rax

    mov eax, edx
    mul ecx
    lea ebx, [eax]
    
    pop rax

    sub ebx, eax
    sub ebx, ecx ; колво элементов для смещения
    ; 1 элемент - 1 байт, поэтому домножать на размер не требуется

    mov rdx, rbx
    lea rsi, [rbx+rcx]

    call memmove

    xor rax, rax

    mov rsp, rbp
    pop rbp
    ret

; rdi - mat ptr
; esi - row count
; edx - column count
remove_max_row:
    push rbp
    mov rbp, rsp
    sub rsp, 16

    ; TODO

    mov rsp, rbp
    pop rbp
    ret

; rdi - mat ptr
; rsi - row count
; rdx - column count
print_matrix:
    push rbp
    mov rbp, rsp
    sub rsp, 32

    mov qword [rbp-8], 0  ; row counter
    mov qword [rbp-16], 0 ; column counter

    mov qword [rbp-24], rsi ; rows
    mov qword [rbp-32], rdx ; columns

.row_loop:
.col_loop:
    mov rax, qword [rbp-24]
    cmp rax, qword [rbp-8]
    je .end

    inc qword [rbp-16]
    jmp .col_loop

    lea rdi, [newline]
    call printf    
    jmp .row_loop

.end:
    mov rsp, rbp
    pop rbp
    ret



section '.rodata'
input_rows_cnt db "Input row count: ", 0
input_cols_cnt db "Input col count: ", 0
input_matrix_msg db "Input matrix", 10, 0
input_cnt_fmt db "%d", 0

input_element_fmt db "%hhd", 0

print_element_fmt db "%hhd ", 0
newline db 10, 0

panic_msg db "Panic!", 10, 0

section '.bss' writable
matrix db ROWS*COLS dup (0xff)

section '.note.GNU-stack'
