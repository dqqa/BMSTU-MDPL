default rel

global main

extern printf

section .text
main:
    push rbp
    mov rbp, rsp
    sub rsp, 32

    fstcw word [rbp-18]

    mov ax, word [rbp-18]
    and ax, 0xFCFF ; 24-bit precision
    mov word [rbp-18], ax

    fldcw word [rbp-18]

    ; res = (pi^2)*15
    fldpi ; loads 80-bit even if control word set to 24-bit precision
    fst st1
    fmulp st1, st0
    fld dword [fifteen]
    fmul st0, st1

    ; fstp dword [rbp-16]
    ; fld dword [rbp-16]
    fstp dword [rbp-16]

    cvtss2sd xmm0, [rbp-16]
    lea rdi, [msg]
    mov rax, 1
    call printf wrt ..plt

    xor rax, rax

    mov rsp, rbp
    pop rbp
    ret

section .rodata
msg db `Result: %.5f\n`, 0
fifteen dd 15.0

section .note.GNU-stack
