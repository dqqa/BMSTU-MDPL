.8086
.model small

StkSeg SEGMENT PARA STACK 'STACK'
    DB 200h DUP (?)
StkSeg ENDS

DataS SEGMENT WORD 'DATA'
HelloMessage DB 'Hello, world !0123456789012345'          ; текст сообщения
    DB 0Ah
    DB 0Dh
    DB '$'                       ; ограничитель для функции DOS
DataS ENDS

Code SEGMENT WORD 'CODE'
    ASSUME CS:Code, DS:DataS
DispMsg:
    mov AX, DataS                ; загрузка в AX адреса сегмента данных
    mov DS, AX                   ; установка DS

    mov cx, 3

    mov DX, OFFSET HelloMessage  ; DS:DX - адрес строки
    mov AH, 9                    ; АН=09h выдать на дисплей строку

print_msg:
    int 21h                      ; вызов функции DOS
    loop print_msg

    mov AH, 7                    ; АН=07h ввести символ без эха
    INT 21h                      ; вызов функции DOS

    mov AH, 4Ch                  ; АН=4Ch завершить процесс
    int 21h                      ; вызов функции DOS
Code ENDS
END DispMsg

