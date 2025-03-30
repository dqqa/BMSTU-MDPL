; Жижин Никита Игоревич. ИУ7-41Б.
; Вариант 2.
; Задание: В графическом режиме 320х200 с 8 битным цветом (см. прерывание int 10h)
; отрисовать анимацию простого цветного огня в нижней части окна (с использованием ГПСЧ).

; Выход осуществляется при нажатии кнопки `q`
.model tiny
.8086

BACKGROUND_COLOR equ 3
TIME_INTERVAL equ 2

LINE1_COLOR equ 41
PEAK1_MAX equ 150
PEAK1_MIN equ 170

LINE2_COLOR equ 44
LINE2_DELTA equ 10

LINE3_COLOR equ 15
LINE3_DELTA equ 30

ROWS equ 200
COLS equ 320

PEAK_COUNT equ 40

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
    sub sp, 12

    mov di, 0123h ; initialize PRNG
    call srand

    mov al, 13h
    int 10h

    xor dx, dx
    mov ax, COLS
    mov bx, PEAK_COUNT
    div bx

    mov word ptr [bp-2], ax ; step between peaks
    mov word ptr [bp-4], ax ; cur x

    mov word ptr [bp-8], 0  ; saved l1.y
    mov word ptr [bp-10], 0  ; saved l2.y
    mov word ptr [bp-12], 0  ; saved l3.y

again:
    cmp p2.x, COLS
    jge endloop

    mov ax, p2.x
    mov p1.x, ax

    mov ax, word ptr [bp-4]
    mov p2.x, ax

; LINE 1
    mov ax, word ptr [bp-8]
    mov p1.y, ax

    call rand
    mov di, ax
    mov si, PEAK1_MAX
    mov dx, PEAK1_MIN
    call clamp

    mov p2.y, ax
    mov word ptr [bp-8], ax

    mov al, LINE1_COLOR
    call drawline

; LINE 2
    mov ax, word ptr [bp-10]
    mov p1.y, ax

;     call rand
;     mov di, ax
;     mov si, PEAK2_MAX
;     mov dx, PEAK2_MIN
;     call clamp

    mov ax, word ptr [bp-8]
    add ax, LINE2_DELTA

    mov p2.y, ax
    mov word ptr [bp-10], ax

    mov al, LINE2_COLOR
    call drawline

; LINE 3
    mov ax, word ptr [bp-12]
    mov p1.y, ax

    mov ax, word ptr [bp-8]
    add ax, LINE3_DELTA

    mov p2.y, ax
    mov word ptr [bp-12], ax

    mov al, LINE3_COLOR
    call drawline

    mov ax, word ptr [bp-4]
    add ax, word ptr [bp-2]
    mov word ptr [bp-4], ax

    mov ah, 06h
    mov dl, 0ffh
    int 21h
    jz again

    cmp al, 'q'
    jnz again
    jmp prg_terminate

endloop:
;     mov word ptr [bp-8], 0
;     mov word ptr [bp-10], 0
;     mov word ptr [bp-12], 0

    mov p1.x, 0
    mov p1.y, 0

    mov p2.x, 0

    mov word ptr [bp-4], 0

    xor ax, ax
    int 1ah ; timer. dx increments each 1/18.2 s
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

prg_terminate:
    mov ax, 0003h
    int 10h ; restore 80x25 16 color text mode

    mov ax, 4c00h
    int 21h

; di - new random seed
srand proc
    mov rand_state, di
    ret
srand endp

; -> ax random number
rand proc
    ; state ^= state << 7;
    ; state ^= state >> 9;
    ; state ^= state << 3;
    ; return state;
    mov ax, rand_state
    mov cx, 7
first_step:
    shl ax, 1 ; невозможно совершить битовый сдивг на более чем 1 в 8086
    loop first_step

    xor rand_state, ax
    mov ax, rand_state

    mov cx, 9
second_step:
    shr ax, 1
    loop second_step

    xor rand_state, ax

    mov ax, rand_state
    mov cx, 3
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

; Bresenham
; al - color
drawline proc
    push bp
    mov bp, sp
    sub sp, 18

    mov bx, p1.x
    mov word ptr [bp-16], bx ; saved p1.x

    mov bx, p1.y
    mov word ptr [bp-18], bx ; saved p1.y

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
    call plot_line_to_border

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

    mov bx, word ptr [bp-16]
    mov p1.x, bx

    mov bx, word ptr [bp-18]
    mov p1.y, bx

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

; di - x
; si - y
; dl - color
plot_line_to_border proc
    mov ax, 0a000h
    mov es, ax

pltb_begin:
    cmp si, ROWS
    je pltb_end

    push dx

    mov ax, si
    mov bx, COLS
    mul bx
    add ax, di

    pop dx
    mov bx, ax
    mov es:[bx], dl

    inc si
    jmp pltb_begin

pltb_end:
    ret
plot_line_to_border endp

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
