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
    ; mov dword [rbp-8], edi
    mov ecx, dword [ebp+16] ; size
    lea eax, [edi+ecx]
    cmp eax, esi
    ja .fwd

    cmp edi, esi
    jb .fwd
    std
    lea esi, [esi+ecx-1]
    lea edi, [edi+ecx-1]

.fwd:
    rep movsb
    cld

    mov byte [edi], 0 ; Терминирующий '\0'

    mov eax, dword [ebp+8]

    mov esp, ebp
    pop ebp
    ret

section .rodata

section .note.GNU-stack
