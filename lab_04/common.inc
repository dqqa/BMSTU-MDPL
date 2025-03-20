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
