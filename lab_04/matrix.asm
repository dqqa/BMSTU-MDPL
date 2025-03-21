format ELF64
include "common.inc"

public remove_max_row

section '.text' executable

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
    mov rax, COLS
    mul esi ; изменяет rdx
    pop rdx

    add rdi, rax ; сместились до строки (dst)

    ; (row_cnt-idx-1) * sizeof(el)
    mov rax, rdx
    sub rax, rsi
    sub rax, 1
    mov rbx, COLS
    mul rbx
    push rax

    mov rsi, rdi
    add rsi, COLS ; src

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
    mov rbx, COLS
    mul rbx

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

section '.rodata'

section '.note.GNU-stack'
