; Жижин Никита Игоревич. ИУ7-41Б.
; Вариант 2.
; Задание: В графическом режиме 320х200 с 8 битным цветом (см. прерывание int 10h)
; отрисовать анимацию простого цветного огня в нижней части окна (с использованием ГПСЧ).

; Выход осуществляется при нажатии кнопки `q`
.model tiny
.8086

BACKGROUND_COLOR equ 3
TIME_INTERVAL equ 2

ROWS equ 200
COLS equ 320

PEAK_COUNT equ 40

.data
    rand_state dw 0
    pixmap db ROWS*COLS dup (3)

.code
    .STARTUP
    push bp
    mov bp, sp
    sub sp, 12

    mov di, 0123h ; initialize PRNG
    call srand

    mov al, 13h
    int 10h

again:
;     call scroll_up
;
;     ; box blur: first horizontal motion blur then vertical motion blur
;     mov word ptr [bp-2], 0
; horz_mb_begin:
;     cmp word ptr [bp-2], ROWS
;     je horz_mb_end
;
;     ; line_blur(j*WIDTH, 1, WIDTH);
;     xor dx, dx
;     mov ax, word ptr [bp-2]
;     mov bx, COLS
;     mul bx
;     mov di, ax
;     mov si, 1
;     mov dx, COLS
;     call line_blur
;
;     inc word ptr [bp-2]
;     jmp horz_mb_begin
; horz_mb_end:
;
;     mov word ptr [bp-2], 0
; vert_mb_begin:
;     cmp word ptr [bp-2], COLS
;     je vert_mb_end
;
;     ; line_blur(i, WIDTH, HEIGHT);
;     mov di, word ptr [bp-2]
;     mov si, COLS
;     mov dx, ROWS
;     call line_blur
;
;     inc word ptr [bp-2]
;     jmp vert_mb_begin
; vert_mb_end:
;
;     ; for (int i = 0; i< WIDTH*HEIGHT; i++)
;     ;     if (rand()%2 && fire[i]>0)
;     ;         fire[i]--;
;     mov word ptr [bp-2], 0
; cool_begin:
;     cmp word ptr [bp-2], ROWS*COLS
;     je cool_end
;
;     call rand
;     test ax, 1
;     jz cool_begin
;
;     mov bx, word ptr [bp-2]
;     cmp byte ptr [pixmap+bx], 0
;     jle cool_begin
;
;     dec byte ptr [pixmap+bx]
;
;     inc word ptr [bp-2]
;     jmp cool_begin
; cool_end:

    ; for (int i = 0; i<WIDTH; i++) {       // add heat to the bed
    ;     int idx = i+(HEIGHT-1)*WIDTH;
    ;     if (!(rand()%32))
    ;         fire[idx] = 128+rand()%128;   // sparks
    ;     else
    ;         fire[idx] = fire[idx]<16 ? 16 : fire[idx]; // ember bed
    ; }
    mov word ptr [bp-2], 0
heat_begin:
    cmp word ptr [bp-2], COLS
    je heat_end

    mov ax, word ptr [bp-2]
    add ax, (ROWS-2)*COLS
    mov word ptr [bp-4], ax ; idx

    call rand
    mov bx, 32
    xor dx, dx
    div bx
    test dx, dx
    jnz heat_nz

    call rand
    xor dx, dx
    mov bx, 128
    div bx
;     add dx, 128

    mov bx, word ptr [bp-4]
    mov byte ptr [pixmap+bx], dl ; sparks

    jmp heat_begin
heat_nz:
    mov bx, word ptr [bp-4]
    cmp byte ptr [pixmap+bx], 16
    jge heat_begin

    mov byte ptr [pixmap+bx], 16

    inc word ptr [bp-2]
    jmp heat_begin
heat_end:

    mov ax, 0a000h
    mov es, ax
    mov si, OFFSET pixmap
    xor di, di
    mov cx, ROWS*COLS
    rep movsb

    inc byte ptr [bp-8]
    mov al, byte ptr [bp-8]
    mov byte ptr [pixmap], al


    jmp again

    mov ah, 06h
    mov dl, 0ffh
    int 21h
    jz again

    cmp al, 'q'
    jnz again
    jmp prg_terminate

endloop:
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

; di - offset
; si - step
; dx - nsteps
line_blur proc
    push bp
    mov bp, sp
    sub sp, 12

    mov byte ptr [bp-3], 0 ; circ[0]
    mov bx, di
    mov al, byte ptr [pixmap+bx]
    mov byte ptr [bp-2], al ; circ[1]
    mov bx, di
    add bx, si
    mov al, byte ptr [pixmap+bx]
    mov byte ptr [bp-1], al ; circ[2]

    mov byte ptr [bp-4], 1 ; beg

    mov word ptr [bp-6], di ; offset
    mov word ptr [bp-8], si ; step
    mov word ptr [bp-10], dx ; nsteps

    mov word ptr [bp-12], 0 ; i

lb_begin:
    mov ax, word ptr [bp-10]
    cmp word ptr [bp-12], ax
    je lb_end

    xor bx, bx

    ; fire[offset] = (circ[0]+circ[1]+circ[2])/3;
    mov al, byte ptr [bp-3]
    mov bl, byte ptr [bp-2]
    add ax, bx
    mov bl, byte ptr [bp-1]
    add ax, bx

    mov bl, 3
    xor dx, dx
    div bx

    mov bx, word ptr [bp-6]
    mov byte ptr [pixmap+bx], al

    ; circ[(beg+++2)%3] = i+2<nsteps ? fire[offset+2*step] : 0;
    mov ax, word ptr [bp-12]
    add ax, 2
    cmp ax, word ptr [bp-10]
    jl lb_l
    xor ax, ax
    jmp lb_ge
lb_l:
    xor bx, bx
    mov bx, word ptr [bp-8]
    shl bx, 1
    add bx, word ptr [bp-6]
    mov al, byte ptr [pixmap+bx]

lb_ge:
    push ax
    ; al = i+2<nsteps ? fire[offset+2*step] : 0
    xor ax, ax
    mov al, byte ptr [bp-4]
    add ax, 2
    mov bx, 3
    div bx

    mov bx, dx ; remainder
    add bx, bp
    sub bx, 2

    pop ax
    mov byte ptr [bx], al

    inc byte ptr [bp-4]

    ; offset += step;
    mov ax, word ptr [bp-8]
    add word ptr [bp-6], ax

    inc word ptr [bp-12]
    jmp lb_begin
lb_end:
    mov sp, bp
    pop bp
    ret
line_blur endp

scroll_up proc
    push bp
    mov bp, sp
    sub sp, 4

    mov word ptr [bp-2], 0 ; row
    mov word ptr [bp-4], 0 ; col

su_j_loop:
    cmp word ptr [bp-2], ROWS
    je su_done
su_i_loop:
    cmp word ptr [bp-4], COLS
    je su_i_end

    mov ax, word ptr [bp-2]
    dec ax
    xor dx, dx
    mov bx, COLS
    mul bx

    mov bx, ax
    add bx, word ptr [bp-4]

    mov al, byte ptr [pixmap+bx-COLS]
    mov byte ptr [pixmap+bx], al

    inc word ptr [bp-4]
    jmp su_i_loop
su_i_end:
    inc word ptr [bp-2]
    mov word ptr [bp-4], 0
    jmp su_j_loop

su_done:
    mov sp, bp
    pop bp
    ret
scroll_up endp

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

