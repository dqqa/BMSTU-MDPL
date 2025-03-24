.model tiny
.8086

BACKGROUND_COLOR equ 3
LINE_COLOR equ 41
TIME_INTERVAL equ 5

ROWS equ 200
COLS equ 320

PEAK_COUNT equ 32

point struct
    x word ?
    y word ?
point ends

.data
    rand_state dw 0

    p1 point {0, 0}
    p2 point {0, 0}

.code
    .STARTUP
    push bp
    mov bp, sp
    sub sp, 8

    mov di, 0123h
    call srand

    ; call rand
    ; call rand
    ; call rand

    mov al, 13h
    int 10h
;
;     mov al, 15
;     call drawline

    xor dx, dx
    mov ax, COLS
    mov bx, PEAK_COUNT
    div bx
    mov word ptr [bp-2], ax ; step between peaks
    mov word ptr [bp-4], ax ; cur x

again:
    cmp p2.x, COLS
    je endloop
    mov ax, p2.x
    mov p1.x, ax

    mov ax, p2.y
    mov p1.y, ax

    call rand
    mov di, ax
    mov si, 0
    mov dx, 50
    call clamp

    mov p2.y, ax
    mov ax, word ptr [bp-4]
    mov p2.x, ax
    push ax

    mov al, LINE_COLOR
    call drawline

    pop ax
    add ax, word ptr [bp-2]
    mov word ptr [bp-4], ax

    jmp again

endloop:
    mov p1.x, 0
    mov p1.y, 0

    mov p2.x, 0
    mov p2.y, 0

    mov word ptr [bp-4], 0

    xor ax, ax
    int 1ah ; increments each 1/18.2 s
    mov word ptr [bp-6], dx ; sleep_start

wait_more:
    xor ax, ax
    int 1ah
    sub dx, word ptr [bp-6]
    cmp dx, TIME_INTERVAL
    je wait_end
    jmp wait_more

wait_end:
    mov al, BACKGROUND_COLOR
    call fill_background

    jmp again
;     mov byte ptr [bp-1], 0
; again:
;     mov al, byte ptr [bp-1]
;     call fill_background
;
;     inc byte ptr [bp-1]
;     jmp again

;     mov di, 264
;     mov si, 1
;     mov dx, 15
;     call clamp
    jmp $
    mov ax, 4c00h
    int 21h

; di - new random seed
srand proc
    mov rand_state, di
    ret
srand endp

; -> ax random number
rand proc
    ; state ^= state << 13;
    ; state ^= state >> 17;
    ; state ^= state << 5;
    ; return state;
    mov ax, rand_state
    mov cx, 3
first_step:
    shl ax, 1 ; невозможно совершить битовый сдивг на более чем 1 в 8086
    loop first_step

    xor rand_state, ax
    mov ax, rand_state

    mov cx, 17
second_step:
    shr ax, 1
    loop second_step

    xor rand_state, ax

    mov ax, rand_state
    mov cx, 5
third_step:
    shl ax, 1
    loop third_step

    xor rand_state, ax

    mov ax, rand_state
    ret
rand endp

; di - value
; si - min value
; dx - max value
clamp proc
    ; return (value % (max - min)) + min;
    sub dx, si ; max - min
    mov ax, di
    mov bx, dx
    xor dx, dx
    div bx

    mov ax, dx ; remainder

    add ax, si
    ret
clamp endp

; al - color
drawline proc
    push bp
    mov bp, sp
    sub sp, 16

    mov byte ptr [bp-12], al ; saved color

; plotLine(x0, y0, x1, y1)
;     dx = abs(x1 - x0)
;     sx = x0 < x1 ? 1 : -1
;     dy = -abs(y1 - y0)
;     sy = y0 < y1 ? 1 : -1
;     error = dx + dy
;
;     while true
;         plot(x0, y0)
;         e2 = 2 * error
;         if e2 >= dy
;             if x0 == x1 break
;             error = error + dy
;             x0 = x0 + sx
;         end if
;         if e2 <= dx
;             if y0 == y1 break
;             error = error + dx
;             y0 = y0 + sy
;         end if
;     end while

    mov di, p2.x
    sub di, p1.x
    call abs
    mov word ptr [bp-2], ax ; dx

    mov ax, p2.x
    sub ax, p1.x
    mov di, ax
    call sign
    mov word ptr [bp-4], ax ; sx

    mov di, p2.y
    sub di, p1.y
    call abs
    neg ax
    mov word ptr [bp-6], ax ; dy

    mov ax, p2.y
    sub ax, p1.y
    mov di, ax
    call sign
    mov word ptr [bp-8], ax ; sy

    mov ax, word ptr [bp-2]
    add ax, word ptr [bp-6]
    mov word ptr [bp-10], ax ; error

dl_begin:
    mov di, p1.x
    mov si, p1.y
    mov dl, byte ptr [bp-12]
    call plot_point

    mov ax, word ptr [bp-10]
    shl ax, 1
    mov word ptr [bp-14], ax ; e2

    cmp ax, word ptr [bp-6]
    jl second_cond
    mov ax, p1.x
    cmp ax, p2.x
    jne do_not_break1
    jmp dl_end

do_not_break1:
    mov ax, word ptr [bp-6]
    add word ptr [bp-10], ax
    mov ax, word ptr [bp-4]
    add p1.x, ax

second_cond:
    mov ax, word ptr [bp-14]
    cmp ax, word ptr [bp-2]
    jg dl_begin
    mov ax, p1.y
    cmp ax, p2.y
    jne do_not_break2
    jmp dl_end

do_not_break2:
    mov ax, word ptr [bp-2]
    add word ptr [bp-10], ax
    mov ax, word ptr [bp-8]
    add p1.y, ax

    jmp dl_begin

dl_end:
    mov sp, bp
    pop bp
    ret

drawline endp

; di - x
; si - y
; dl - color
plot_point proc
    mov ax, 0a000h
    mov es, ax
    push dx

    mov ax, si
    mov bx, COLS
    mul bx
    add ax, di

    pop dx
    mov bx, ax
    mov es:[bx], dl
    ret
plot_point endp

; al - color
fill_background proc
    push bp
    mov bp, sp
    sub sp, 5

    mov bx, 0a000h
    mov es, bx
    xor di, di

    mov cx, ROWS*COLS
    rep stosb

    mov sp, bp
    pop bp
    ret
fill_background endp

; di - value
abs proc
    cmp di, 0
    jle abs_neg
    jmp abs_noneg
abs_neg:
    neg di
abs_noneg:
    mov ax, di
    ret
abs endp

; di - value
sign proc
    cmp di, 0
    jl sign_eq
    je sign_zero
    mov ax, 1
    jmp sign_end
sign_eq:
    mov ax, -1
    jmp sign_end
sign_zero:
    xor ax, ax
sign_end:
    ret
sign endp
END


;     mov word ptr [bp-2], 0 ; rows counter
;     mov word ptr [bp-4], 0 ; cols counter
;
;     mov byte ptr [bp-5], al ; save color
; fb_rows_loop:
;     cmp word ptr [bp-2], ROWS
;     je fb_end
; fb_cols_loop:
;     cmp word ptr [bp-4], COLS
;     je fb_cols_end
;
;     mov ax, word ptr [bp-2]
;     mov bx, COLS
;     mul bx
;     add ax, word ptr [bp-4]
;     mov bx, ax
;
;     mov al, byte ptr [bp-5]
;     mov es:[bx], al
;
;     inc word ptr [bp-4]
;
;     jmp fb_cols_loop
;
; fb_cols_end:
;     mov word ptr [bp-4], 0
;     inc word ptr [bp-2]
;     jmp fb_rows_loop
;
; fb_end:
