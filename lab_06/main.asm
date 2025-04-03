.8086
.model tiny

code SEGMENT
    ASSUME cs:code, ds:code
    ORG 100h

start:
    jmp main

    ; Все находится в сегменте CS, т.к. внутри прерывания будет доступен только он
    cur_state db 11111b
    pattern dw 0DEADh
    last_time db ?
    old_handler dd ?

handler proc
    push ax
    push bx
    push cx
    push dx
    push ds
    push es

    ; dh - seconds
    mov ah, 02 ; GetCurrentTime
    int 1ah

    cmp cs:last_time, dh
    je handler_exit
    mov cs:last_time, dh

    call change_speed

handler_exit:
    pushf
    call cs:old_handler

    pop es
    pop ds
    pop dx
    pop cx
    pop bx
    pop ax
    iret
handler endp

change_speed proc
    mov al, 0f3h
    out 60h, al

    mov al, 00100000b
    or al, cs:cur_state
    out 60h, al

    ; cs: т.к. мы находимся в прерывании, т.е. ds, и остальные сегментные регистры отличаются от нашего cs!
    dec cs:cur_state
    cmp cs:cur_state, 0
    jl cs_reset
    jmp cs_exit

cs_reset:
    mov cur_state, 11111b

cs_exit:
    ret
change_speed endp

main:
    xor ax, ax
    mov al, cur_state
    call print_num

    mov ax, 3509h
    int 21h

    ; Сравнение с паттерном. Если ISR (Interrupt Service Routine) не зарегистрирован, es:pattern будет отличаться (вероятно) от 0xDEAD
    ; Можно сравнивать OFFSET handler (надежнее).
    cmp es:pattern, 0DEADh
    je unregister

    mov word ptr old_handler, bx
    mov word ptr old_handler+2, es

    mov ax, 2509h
    mov dx, OFFSET handler
    int 21h

    mov dx, OFFSET registered_msg
    mov ah, 09h
    int 21h

    mov dx, OFFSET main
    int 27h

unregister:
    push ds
    push es

    mov dx, word ptr es:old_handler
    mov ds, word ptr es:old_handler+2
    mov ax, 2509h
    int 21h

    pop es
    pop ds

    ; Чистим память
    mov ah, 49h
    int 21h
    jnc no_error

    mov ah, 09h
    mov dx, OFFSET error_msg
    int 21h
    jmp exit

no_error:
    mov dx, OFFSET unregistered_msg
    mov ah, 09h
    int 21h

exit:
    ; Восстановим частоту повтора клавиатуры
    mov al, 0f3h
    out 60h, al
    mov al, 00100000b
    out 60h, al

    mov ax, 4c00h
    int 21h

; ax - num
print_num proc
    push bp
    mov bp, sp
    sub sp, 4

    mov word ptr [bp-2], ax

pn_begin:
    cmp word ptr [bp-2], 0
    je pn_end

    mov bx, word ptr [bp-2]
    and bx, 1111000000000000b
    mov cx, 12
pn_shr_begin:
    shr bx, 1
    loop pn_shr_begin

    mov dl, byte ptr [hex_digits+bx]
    mov ah, 02h
    int 21h

    mov cx, 4
pn_div_loop:
    shl word ptr [bp-2], 1
    loop pn_div_loop

    jmp pn_begin

pn_end:
    mov dx, OFFSET newline
    mov ah, 09h
    int 21h

    mov sp, bp
    pop bp
    ret
print_num endp

; Тут, т.к. эту память можно после регистрации ISR освободить
registered_msg db "Successfully registered!", 0Ah, 0Dh, '$'
unregistered_msg db "Successfully unregistered!", 0Ah, 0Dh, '$'
error_msg db "An error occured!", 0Ah, 0Dh, '$'

newline db 0Ah, 0Dh, '$'

hex_digits db "0123456789ABCDEF"

code ENDS
END start
