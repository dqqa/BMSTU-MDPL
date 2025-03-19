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

    push rdx
    mov rax, rcx
    mul esi ; изменяет rdx
    pop rdx

    add rdi, rax ; сместились до строки (dst)

    ; (row_cnt-idx-1) * sizeof(el)
    mov rax, rdx
    sub rax, rsi
    sub rax, 1
    mul ecx
    push rax

    mov rsi, rdi
    add rsi, rcx ; src

    pop rdx ; size (bytes)
    call memmove

    xor rax, rax

    mov rsp, rbp
    pop rbp
    ret

; rdi - mat ptr
; rsi - row count ptr
; rdx - column count
remove_max_row:
    push rbp
    mov rbp, rsp
    sub rsp, 64

    mov qword [rbp-8], 0  ; row counter
    mov qword [rbp-16], 0 ; column counter

    mov eax, dword [rsi]
    mov qword [rbp-24], rax ; rows
    mov qword [rbp-32], rdx ; columns

    mov qword [rbp-40], rdi ; saved mat ptr

    mov dword [rbp-44], 0 ; max sum
    mov dword [rbp-48], 0 ; cur sum
    mov qword [rbp-56], 0 ; max index
    
    dec dword [rsi]
    

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
    mul qword [rbp-32]
    add rsi, rax
    add rsi, qword [rbp-16]
    mov sil, byte [rsi]
    and esi, 0xff

    add dword [rbp-48], esi

    inc qword [rbp-16]
    jmp .col_loop

.col_end:
    mov eax, dword [rbp-48]
    cmp eax, dword [rbp-44]
    jle .not_greater
    mov dword [rbp-44], eax ; если сумма больше чем макс
    mov rax, qword [rbp-8]
    mov qword [rbp-56], rax ; устанавливаем новую строку с максимальной суммой элементов

.not_greater:
    mov dword [rbp-48], 0 ; сбрасываем текущую сумму
    mov qword [rbp-16], 0 ; обнуляем счетчик столбцов
    inc qword [rbp-8] ; увеличиваем счетчик строк
    jmp .row_loop

.end:
    mov rdi, qword [rbp-40]
    mov rsi, qword [rbp-56]
    mov rdx, qword [rbp-24]
    mov rcx, qword [rbp-32]
    call delete_matrix_row

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
    mul qword [rbp-32]
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
input_rows_cnt db "Input row count: ", 0
input_cols_cnt db "Input col count: ", 0
input_matrix_msg db "Input matrix", 10, 0
input_cnt_fmt db "%d", 0

input_element_fmt db "%hhd", 0

print_element_fmt db "%hhd ", 0
newline db 10, 0

panic_msg db "Panic!", 10, 0

result_msg db "Result:", 10, 0

section '.bss' writable
matrix db ROWS*COLS dup (?)

section '.note.GNU-stack'
