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
    myrect rect {}

.code
    .STARTUP
    push bp
    mov bp, sp
    sub sp, 4

    mov myrect.origin.x, 15
    mov myrect.origin.y, 50

    mov myrect.sz.x, 20
    mov myrect.sz.y, 50

    mov al, 13h
    int 10h

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
    jmp $
END
