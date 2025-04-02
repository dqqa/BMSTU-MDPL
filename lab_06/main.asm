.8086
.model tiny

code SEGMENT
    ASSUME cs:code, ds:code
    ORG 100h
start:
    jmp init

    registered_msg db "Successfully registered!", 0Ah, 0Dh, '$'
    unregistered_msg db "Successfully unregistered!", 0Ah, 0Dh, '$'
    test_msg db "Test", 0Dh, 0Ah, '$'

    cur_state db 11111b
    is_registered dw 0DEADh
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
    mov ah, 02
    int 1ah

    cmp last_time, dh
    je handler_exit
    mov last_time, dh

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

    xor al, al
    or al, 00100000b
    or al, cur_state
    out 60h, al

    dec cur_state
    cmp cur_state, 0
    jl cs_reset
    jmp cs_exit

cs_reset:
    mov cur_state, 11111b

cs_exit:
    ret
change_speed endp

init:
    mov ax, 3509h
    int 21h

    cmp es:is_registered, 0DEADh ; Сравнение с паттерном. Если ISR не зарегистрирован, es:is_registered будет отличаться (вероятно) от 0xDEAD
    je unregister

    mov word ptr old_handler, bx
    mov word ptr old_handler+2, es

    mov ax, 2509h
    mov dx, OFFSET handler
    int 21h

    mov dx, OFFSET registered_msg
    mov ah, 09h
    int 21h

    mov dx, OFFSET init
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

    mov al, 0f3h
    out 60h, al

    mov al, 00100000b
    out 60h, al

    mov dx, OFFSET unregistered_msg
    mov ah, 09h
    int 21h

    mov ax, 4c00h
    int 21h
code ENDS
END start
