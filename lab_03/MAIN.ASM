.model small

charNumber equ (4-1)

stackSeg SEGMENT STACK 'STACK'
    db 200h dup (?)
stackSeg ENDS

dataSeg SEGMENT 'DATA'
    panicMsg db "An error occured!", 0Dh, 0Ah, '$'
    resultMsg db "Result: $"
    enterMsg db "Enter characters: $"
    newline db 0Dh, 0Ah, '$'
dataSeg ENDS

codeSeg SEGMENT 'CODE'
    ASSUME cs:codeSeg, ds:dataSeg, ss:stackSeg

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

main proc near
    push bp
    mov bp, sp
    sub sp, 4

    mov ax, dataSeg
    mov ds, ax

    mov dx, OFFSET enterMsg
    mov ah, 09h
    int 21h

    xor cx, cx                   ; Здесь хранится индекс введенного символа

again:
    call getchar                 ; возврат через al
    cmp al, 0Dh                  ; встретили конец строки
    je done

    cmp cx, charNumber
    jne skip                     ; cmove появился только с запуском Pentium Pro :(
    mov BYTE PTR [bp-1], al

skip:
    inc cx
    jmp again

done:
    cmp cx, charNumber
    jg ok
    call panic

ok:
    mov dx, OFFSET resultMsg
    mov ah, 09h
    int 21h

    add BYTE PTR [bp-1], 'A'-'a' ; Смещаемся в ASCII-таблице
    mov dl, BYTE PTR [bp-1]
    mov ah, 02h
    int 21h

    mov dx, OFFSET newline
    mov ah, 09h
    int 21h

    mov sp, bp
    pop bp

    mov ax, 4c00h
    int 21h
main endp
codeSeg ENDS

END main
