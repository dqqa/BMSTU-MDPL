default rel

global print_signed_decimal

extern printf

section .text
; di - number
print_signed_decimal:
    push rbp
    mov rbp, rsp
    sub rsp, 16

    and di, 0xff ; "обрезаем" число до 8 бит
    mov sil, dil
    lea rdi, [print_8bit_fmt]
    call printf wrt ..plt

    mov rsp, rbp
    pop rbp
    ret

section .rodata
print_8bit_fmt db `Stripped signed decimal: %hhi\n`, 0

section .note.GNU-stack
