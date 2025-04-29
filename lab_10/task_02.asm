default rel

section .text
global main

extern printf

main:
    push ebp
    mov ebp, esp
    sub esp, 16

    fldcw word [ebp-2]
    and word [ebp-2], 0b1111110011111111
    or word [ebp-2],  0b0000001000000000

    fldcw word [ebp-2]

    finit

    ; 3.14
    fld tword [pi_1]
    fsin

    fstp qword [esp]

    push sin_pi
    call printf
    
    fld tword [pi_1]
    fld tword [two]
    fdivp st1, st0
    fsin

    fstp qword [esp]

    push sin_pi_2
    call printf
    
    ; 3.141596
    fld tword [pi_2]
    fsin

    fstp qword [esp]

    push sin_pi
    call printf
    
    fld tword [pi_2]
    fld tword [two]
    fdivp st1, st0
    fsin

    fstp qword [esp]

    push sin_pi_2
    call printf
    
    ; Internal
    fldpi
    fsin

    fstp qword [esp]

    push sin_pi
    call printf
    
    fldpi
    fld tword [two]
    fdivp st1, st0
    fsin

    fstp qword [esp]

    push sin_pi_2
    call printf

    xor eax, eax

    mov esp, ebp
    pop ebp
    ret

section .rodata
sin_pi db "sin(pi): %.10f", 10, 0
sin_pi_2 db "sin(pi/2): %.10f", 10, 0

pi_1 dt 3.14
pi_2 dt 3.141596
two dt 2.0

section .note.GNU-stack
