section .text
global main

extern printf, scanf, puts, exit

; sin(x^2+5x) - 1 вариант
; double func(double x);
; Return: st(0)
func:
    push ebp
    mov ebp, esp
    sub esp, 8

    fld qword [ebp+8]
    fst st1
    fmulp
    fstp qword [ebp-8] ; x^2

    fld qword [ebp+8]
    fld qword [five]
    fmulp
    fld qword [ebp-8]
    faddp
    fsin

    mov esp, ebp
    pop ebp
    ret

; double bisection_method(double a, double b, int max_iters)
bisection_method:
    push ebp
    mov ebp, esp
    sub esp, 52

    mov eax, dword [ebp+8]
    mov dword [ebp-48], eax
    mov eax, dword [ebp+12]
    mov dword [ebp-44], eax ; Saved a
    
    mov eax, dword [ebp+16]
    mov dword [ebp-56], eax
    mov eax, dword [ebp+20]
    mov dword [ebp-52], eax ; Saved b

    mov dword [ebp-28], 0 ; int i = 0;
    jmp .condition
.begin:
    fld qword [ebp-48]
    fadd qword [ebp-56]
    fld qword [two]
    fdivp st1, st0
    fstp qword [ebp-16]
    
    sub esp, 8
    push dword [ebp-12]
    push dword [ebp-16]
    call func
    add esp, 16

    ; if (fabs(f(c)) < EPS || (b - a) / 2 < EPS)
    fabs
    fld qword [eps]
    fcomip st0, st1
    fstp st0
    ja .found
    ; fld qword [ebp-56] ; (b - a) / 2 < TOL
    ; fsub qword [ebp-48]
    ; fld qword [two]
    ; fdivp st1, st0
    ; fld qword [eps]
    ; fcomip st0, st1
    ; fstp st0
    jbe .not_found
.found:
    fld qword [ebp-16]
    jmp .end
.not_found:
    add dword [ebp-28], 1

    sub esp, 8
    push dword [ebp-12]
    push dword [ebp-16]
    call func
    add esp, 16

    fldz
    fcomip st0, st1
    fstp st0
    jbe .be_fc ; int sig_c = f(c) < 0 ? -1 : 1;
    mov eax, -1
    jmp .next_c
.be_fc:
    mov eax, 1
.next_c:
    mov dword [ebp-24], eax

    sub esp, 8
    push dword [ebp-44]
    push dword [ebp-48]
    call func
    add esp, 16
    
    fldz
    fcomip st0, st1
    fstp st0
    jbe .be_fa ; int sig_a = f(a) < 0 ? -1 : 1
    mov eax, -1
    jmp .next_a
.be_fa:
    mov eax, 1
.next_a:
    mov dword [ebp-20], eax
    mov eax, dword [ebp-24]
    cmp eax, dword [ebp-20]
    jne .swp

    fld qword [ebp-16]
    fstp qword [ebp-48]
    jmp .condition
.swp:
    fld qword [ebp-16]
    fstp qword [ebp-56]

.condition:
    mov eax, dword [ebp-28]
    cmp eax, dword [ebp+24]
    jl .begin

    sub esp, 12
    push error_msg
    call puts
    add esp, 16
    fldz

    push 1
    call exit
.end:
    mov ebx, dword [ebp-4]
    leave
    ret

main:
    push ebp
    mov ebp, esp
    sub esp, 32

    push prompt_msg
    call printf
    add esp, 4

    lea eax, [ebp-4]
    push eax
    lea eax, [ebp-8]
    push eax
    lea eax, [ebp-12]
    push eax

    push input_fmt
    call scanf
    add esp, 16

    sub esp, 4
    mov eax, [ebp-4]
    mov dword [esp+16], eax

    fld dword [ebp-12]
    fld dword [ebp-8]
    fstp qword [esp+8]
    fstp qword [esp]
    call bisection_method
    add esp, 24

    sub esp, 4
    fstp qword [esp]
    push result_msg
    call printf
    add esp, 16

    xor eax, eax

    mov esp, ebp
    pop ebp
    ret

section .rodata
prompt_msg db "Введите через пробел отрезок (начало, конец) и кол-во итераций: ", 0
error_msg db "Невозможно вычислить корень функции!", 10, 0
input_fmt db "%f %f %d", 0
result_msg db "Корень: %f", 10, 0

five dq 5.0
eps dq 0.000001
two dq 2.0
section .note.GNU-stack
