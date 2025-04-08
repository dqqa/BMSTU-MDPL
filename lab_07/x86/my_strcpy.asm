default rel

global my_strcpy

section .text

; char *my_strcpy(char *dst, const char *src, size_t size);
my_strcpy:
    push ebp
    mov ebp, esp
    sub esp, 16

    mov edi, dword [ebp+8]  ; dst
    mov esi, dword [ebp+12] ; src
    mov ecx, dword [ebp+16] ; size

    cmp edi, esi
    je .end ; Do nothing
    jb .fwd ; dest < src

    mov eax, esi
    add eax, ecx
    cmp edi, eax
    jae .fwd ; (dest > src) && (dest >= src+cnt)

    std
    lea esi, [esi+ecx-1]
    lea edi, [edi+ecx-1]
    rep movsb
    cld

    add edi, dword [ebp+16]
    inc edi
    mov byte [edi], 0 ; Терминирующий '\0'
    jmp .end

.fwd:
    rep movsb
    mov byte [edi], 0 ; Терминирующий '\0'

.end:
    mov eax, dword [ebp+8]

    mov esp, ebp
    pop ebp
    ret

section .rodata

section .note.GNU-stack
