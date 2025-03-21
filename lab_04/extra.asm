.8086
.model tiny

vec2 struct
    x word ?
    y word ?
vec2 ends

rect struct
    origin vec2 {?, ?}
    sz vec2 {?, ?}
rect ends

.data
    myrect rect {{10, 10}, {20, 50}}

.code
    .STARTUP
    push bp
    mov bp, sp
    sub sp, 4

    mov al, 13h
    int 10h

again:
    mov word ptr [bp-2], 0 ; x
    mov word ptr [bp-4], 0 ; y

    xor ax, ax
    xor bx, bx
row_loop:
    mov ax, [bp-4]
    cmp ax, myrect.sz.y ; y counter
    je end_loop

    mov bx, rect.sz.x ; x counter
col_loop:
    mov ax, [bp-2]
    cmp ax, myrect.sz.x
    je end_col

    mov ax, 320
    mov bx, myrect.origin.y
    mul bx
    push ax

    mov ax, [bp-4]
    mov bx, 320
    mul bx
    pop bx

    add ax, bx

    add ax, [bp-2]
    add ax, myrect.origin.x

    mov bx, ax

    mov ax, 0a000h
    mov es, ax
    mov byte ptr es:[bx], 15

    inc word ptr [bp-2]
    jmp col_loop

end_col:
    inc word ptr [bp-4]
    mov word ptr [bp-2], 0
    jmp row_loop

end_loop:

mouse_loop:
    mov ax, 3
    int 33h
    and bx, 00000001b ; LMB clicked
    jnz mouse_endloop
    jmp mouse_loop

mouse_endloop:
    ; clear screen
    push dx
    push cx

    xor di, di
    mov ax, 0a000h
    mov es, ax
    mov cx, 320*200
    mov al, 0
    rep stosb

    xor dx, dx
    
    ; позиция курсора по Х в диапазоне 0..639. Делим на 2.
    pop cx
    mov ax, cx
    mov bx, 2
    div bx
    mov cx, ax

    pop dx
    mov myrect.origin.x, cx
    mov myrect.origin.y, dx
    jmp again
END
