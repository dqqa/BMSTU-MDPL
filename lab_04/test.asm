format ELF64


section '.text' executable

extrn printf
public main

main:
    push rbp
    mov rbp, rsp
    sub rsp, 16

    lea rdi, [msg]
    call PLT printf

    xor rax, rax

    mov rsp, rbp
    pop rbp
    ret

section '.rodata'
msg db "Hello world!", 10, 0

section '.note.GNU-stack'
