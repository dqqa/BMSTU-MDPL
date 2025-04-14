; Dependencies:
; - GTK3 - `sudo apt install libgtk-3-dev`

default rel

%define WINDOW_WIDTH 200
%define WINDOW_HEIGHT 200
%define BASE 10

%define GTK_DIALOG_MODAL 1

%define GTK_MESSAGE_INFO 0
%define GTK_MESSAGE_ERROR 3

%define GTK_BUTTONS_OK 1

section .text
    global main
    extern gtk_application_new, g_application_run, g_object_unref, gtk_application_window_new
    extern gtk_window_set_title, gtk_window_set_default_size, gtk_grid_new, gtk_button_new_with_label
    extern gtk_entry_new, gtk_container_add, gtk_grid_attach, gtk_widget_show_all, g_signal_connect_data
    extern gtk_widget_destroyed, gtk_widget_destroy, gtk_entry_get_text, strtoll
    extern gtk_message_dialog_new, gtk_main_quit
main:
    push rbp
    mov rbp, rsp
    sub rsp, 32

    mov [rbp-16], rdi ; argc
    mov [rbp-24], rsi ; argv

    lea rdi, [app_id]
    xor esi, esi
    call gtk_application_new wrt ..plt
    mov qword [rbp-8], rax ; GtkApplication *app

    mov rdi, qword [rbp-8]
    lea rsi, [sig_activate]
    lea rdx, [activate]
    xor rcx, rcx
    xor r8, r8
    xor r9, r9
    call g_signal_connect_data wrt ..plt

    mov rdi, [rbp-8]
    mov rsi, [rbp-16]
    mov rdx, [rbp-24]
    call g_application_run wrt ..plt
    mov [rbp-28], eax ; status

    mov rdi, [rbp-8]
    call g_object_unref wrt ..plt

    mov eax, [rbp-28]

    mov rsp, rbp
    pop rbp
    ret

on_window_destroy:
    jmp gtk_main_quit wrt ..plt

; static void activate(GtkApplication *app, gpointer user_data)
activate:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    
    mov [rbp-8], rdi ; app
    call gtk_application_window_new wrt ..plt
    mov [rbp-16], rax ; GtkWidget *window

    mov rdi, rax
    lea rsi, [window_name]
    call gtk_window_set_title wrt ..plt
    
    ; Let GTK automatically set size of window

    ; mov rdi, [rbp-16]
    ; mov esi, WINDOW_WIDTH
    ; mov edx, WINDOW_HEIGHT
    ; call gtk_window_set_default_size wrt ..plt

    mov rdi, [rbp-16]
    lea rsi, [sig_destroy]
    ; lea rdx, [on_window_destroy]
    mov rdx, [gtk_widget_destroyed wrt ..got]
    ; lea rcx, [rbp-16]
    xor rcx, rcx
    xor r8, r8
    xor r9, r9
    call g_signal_connect_data wrt ..plt

    call gtk_grid_new wrt ..plt
    mov [rbp-24], rax ; GtkWidget *grid

    lea rdi, [calc_pow_btn_text]
    call gtk_button_new_with_label wrt ..plt
    mov [rbp-32], rax ; GtkWidget *button

    call gtk_entry_new wrt ..plt
    mov [rbp-40], rax ; GtkWidget *text_entry

    mov rdi, [rbp-16]
    mov rsi, [rbp-24]
    call gtk_container_add wrt ..plt

    ; attach button
    mov rdi, [rbp-24]
    mov rsi, [rbp-32]
    xor edx, edx
    xor ecx, ecx
    mov r8d, 1
    mov r9d, 1
    call gtk_grid_attach wrt ..plt

    ; attach text entry
    mov rdi, [rbp-24]
    mov rsi, [rbp-40]
    xor edx, edx
    mov ecx, 1
    mov r8d, 1
    mov r9d, 1
    call gtk_grid_attach wrt ..plt

    mov rdi, [rbp-32]
    lea rsi, [sig_clicked]
    lea rdx, [calc_and_display_pow]
    mov rcx, [rbp-40]
    xor r8, r8
    xor r9, r9
    call g_signal_connect_data wrt ..plt

    mov rdi, [rbp-16]
    call gtk_widget_show_all wrt ..plt

    mov rsp, rbp
    pop rbp
    ret

; static void on_dialog_response(GtkDialog *dialog, gint response_id, gpointer user_data)
on_dialog_response:
    push rbp
    mov rbp, rsp

    call gtk_widget_destroy wrt ..plt

    mov rsp, rbp
    pop rbp
    ret

; static int find_nearest_power(long long num)
find_nearest_power:
    push rbp
    mov rbp, rsp
    sub rsp, 32

    mov qword [rbp-24], rdi ; num
    mov dword [rbp-4], 0 ; pow
    mov qword [rbp-16], 1 ; n
.again:
    mov rax, qword [rbp-16]
    cmp rax, qword [rbp-24]
    jge .end

    shl qword [rbp-16], 1
    inc dword [rbp-4]
    jmp .again

.end:
    mov eax, dword [rbp-4]

    mov rsp, rbp
    pop rbp
    ret

; static void calc_and_display_pow(GtkWidget *widget, gpointer data)
calc_and_display_pow:
    push rbp
    mov rbp, rsp
    sub rsp, 48

    mov [rbp-8], rdi ; GtkWidget *widget
    mov rdi, rsi ; gpointer data
    call gtk_entry_get_text wrt ..plt
    mov [rbp-16], rax ; const gchar *text
    test rax, rax ; if (text && *text)
    jz .err
    cmp byte [rax], 0
    je .err

    mov rdi, [rbp-16]
    lea rsi, [rbp-24] ; char *endptr
    mov edx, BASE
    call strtoll wrt ..plt
    mov [rbp-32], rax ; long long num
    mov rax, [rbp-24]
    cmp byte [rax], 0 ; if (*endptr != '\0')
    jne .err

    mov rdi, [rbp-32]
    call find_nearest_power
    mov [rbp-36], eax ; int pow

    xor rdi, rdi ; parent
    mov esi, GTK_DIALOG_MODAL
    mov edx, GTK_MESSAGE_INFO
    mov ecx, GTK_BUTTONS_OK
    lea r8, [res_msg]
    mov r9d, [rbp-36]
    call gtk_message_dialog_new wrt ..plt
    mov [rbp-48], rax ; GtkWidget *msg_dialog

    mov rdi, rax
    lea rsi, [sig_response]
    lea rdx, [on_dialog_response]
    mov rcx, rax
    xor r8, r8
    xor r9, r9
    call g_signal_connect_data wrt ..plt

    mov rdi, [rbp-48]
    call gtk_widget_show_all wrt ..plt

    jmp .end

.err:
    xor rdi, rdi ; parent
    mov esi, GTK_DIALOG_MODAL
    mov edx, GTK_MESSAGE_ERROR
    mov ecx, GTK_BUTTONS_OK
    lea r8, [err_msg]
    call gtk_message_dialog_new wrt ..plt
    mov [rbp-48], rax ; GtkWidget *msg_dialog

    mov rdi, rax
    lea rsi, [sig_response]
    lea rdx, [on_dialog_response]
    mov rcx, rax
    xor r8, r8
    xor r9, r9
    call g_signal_connect_data wrt ..plt

    mov rdi, [rbp-48]
    call gtk_widget_show_all wrt ..plt
.end:
    mov rsp, rbp
    pop rbp
    ret

section .rodata
app_id db "org.gtk.lab_08", 0
window_name db "Lab 08", 0

sig_clicked db "clicked", 0
sig_response db "response", 0
sig_activate db "activate", 0
sig_destroy db "destroy", 0

calc_pow_btn_text db "Вычислить степень", 0
res_msg db "Ближайшая степень двойки: %d.", 0
err_msg db "Возникла ошибка!", 0

section .note.GNU-stack
