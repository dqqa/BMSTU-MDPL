.model small

stack SEGMENT STACK 'STACK'
    db 200h dup (?)
stack ENDS

data SEGMENT 'DATA'
    panicMsg db "An error occured!", 0Dh, 0Ah, '$'
    helloMsg db "Hello world", 0Dh, 0Ah, '$'
data ENDS

code SEGMENT 'CODE'
    ASSUME cs:code, ds:data

panic proc near
    mov dx, OFFSET panicMsg
    mov ah, 09h
    int 21h
    mov ax, 4c01h
    int 21h
panic endp

getchar proc near
    mov ah, 01
    int 21h
    and ax, 0ffh
    ret
getchar endp

; ds:dx buffer ptr
inputString proc near
    call panic
inputString

func proc near
    mov dx, OFFSET helloMsg
    mov ah, 09h
    int 21h
    ret
func endp

main proc near
    mov ax, data
    mov ds, ax

    call getchar
    sub al, '0'
    cmp al, 0
    jle panic
    xor cx, cx
    mov cl, al
again:
    call func
    mov ax, ip
    push ax
    jmp func
    loop again

    mov ax, 4c00h
    int 21h
main endp
code ENDS

END main
