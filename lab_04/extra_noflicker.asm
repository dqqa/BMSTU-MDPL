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
    backbuffer db 320*200 dup (0)

.code
    .STARTUP
    push bp
    mov bp, sp
    sub sp, 4

    mov al, 13h
    int 10h

again:
    mov ax, ds
    mov es, ax
    mov di, OFFSET backbuffer
    xor al, al
    mov cx, SIZEOF backbuffer
    rep stosb

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

    mov byte ptr ds:[backbuffer+bx], 15

    ; mov ax, 0a000h
    ; mov es, ax
    ; mov byte ptr es:[bx], 15

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
    push dx
    push cx

    ; present of backbuffer (copy to video memory)
    call wait_sync
    cld
    mov si, OFFSET backbuffer

    xor di, di
    mov ax, 0a000h
    mov es, ax
    mov cx, 320*200
    rep movsb

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

; https://stackoverflow.com/questions/43794402/avoid-blinking-flickering-when-drawing-graphics-in-8086-real-mode
; https://wiki.osdev.org/VGA_Hardware#Read/Write_logic
; https://www.eng.auburn.edu/~sylee/ee2220/8086_instruction_set.html#OUT
; http://www.osdever.net/FreeVGA/vga/crtcreg.htm#0A

wait_sync:
    mov dx,03DAh
wait_end:
    in al,dx
    test al,8
    jnz wait_end
wait_start:
    in al,dx
    test al,8
    jz wait_start
    ret

DISABLE_SCREEN_UPDATES PROC
    ; Access the Sequence Controller
    MOV DX, 3C4h    ; Sequence Controller Index Register
    MOV AL, 01h     ; Index 01:h Clocking Mode Register
    OUT DX, AL       ; Select the register

    ; Read the current value of the Clocking Mode Register
    INC DX           ; Port 3C5h (data)
    IN AL, DX        ; Read the current value

    ; Set the Display Disable (DD) bit (bit 5)
    OR AL, 20h      ; Set bit 5 (DD = 1)

    ; Write the new value back to the Clocking Mode Register
    OUT DX, AL       ; Disable screen updates

    RET
DISABLE_SCREEN_UPDATES ENDP

ENABLE_SCREEN_UPDATES PROC
    ; Access the Sequence Controller
    MOV DX, 3C4h    ; Sequence Controller Index Register
    MOV AL, 01h     ; Index 01:h Clocking Mode Register
    OUT DX, AL       ; Select the register

    ; Read the current value of the Clocking Mode Register
    INC DX           ; Port 3C5h (data)
    IN AL, DX        ; Read the current value

    ; Clear the Display Disable (DD) bit (bit 5)
    AND AL, 0DFh     ; Clear bit 5 (DD = 0)

    ; Write the new value back to the Clocking Mode Register
    OUT DX, AL       ; Enable screen updates

    RET
ENABLE_SCREEN_UPDATES ENDP

FREEZE_SCREEN PROC
    ; Disable the cursor
    MOV DX, 3D4h    ; CRT Controller Index Register
    MOV AL, 0Ah     ; Index 0A:h Cursor Start Register
    OUT DX, AL
    INC DX           ; Port 3D5h (data)
    MOV AL, 20h     ; Disable cursor (bit 5 = 1)
    OUT DX, AL

    ; Freeze the CRT controller's memory address
    MOV DX, 3D4h    ; CRT Controller Index Register
    MOV AL, 0Ch     ; Index 0C:h Start Address High
    OUT DX, AL
    INC DX           ; Port 3D5h (data)
    IN AL, DX        ; Read current Start Address High
    MOV AH, AL       ; Save it in AH

    MOV DX, 3D4h    ; CRT Controller Index Register
    MOV AL, 0Dh     ; Index 0D:h Start Address Low
    OUT DX, AL
    INC DX           ; Port 3D5h (data)
    IN AL, DX        ; Read current Start Address Low
    MOV AL, AH       ; Restore Start Address High

    ; Write the same Start Address High and Low repeatedly
    ; This prevents the CRT controller from advancing
    MOV CX, 1000     ; Number of times to repeat (arbitrary)
freeze_loop:
    MOV DX, 3D4h    ; CRT Controller Index Register
    MOV AL, 0Ch     ; Index 0C:h Start Address High
    OUT DX, AL
    INC DX           ; Port 3D5h (data)
    MOV AL, AH       ; Write saved Start Address High
    OUT DX, AL

    MOV DX, 3D4h    ; CRT Controller Index Register
    MOV AL, 0Dh     ; Index 0D:h Start Address Low
    OUT DX, AL
    INC DX           ; Port 3D5h (data)
    MOV AL, AH       ; Write saved Start Address High again
    OUT DX, AL

    LOOP freeze_loop ; Repeat to keep the screen frozen

    RET
FREEZE_SCREEN ENDP

UNFREEZE_SCREEN PROC
    ; Re-enable the cursor
    MOV DX, 3D4h    ; CRT Controller Index Register
    MOV AL, 0Ah     ; Index 0A:h Cursor Start Register
    OUT DX, AL
    INC DX           ; Port 3D5h (data)
    MOV AL, 00h     ; Enable cursor (bit 5 = 0)
    OUT DX, AL

    ; Allow the CRT controller to advance through video memory
    ; (No need to explicitly write to Start Address High/Low)
    RET
UNFREEZE_SCREEN ENDP
END
