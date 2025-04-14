	.file	"main.c"
	.intel_syntax noprefix
	.text
	.type	find_nearest_power, @function
find_nearest_power:
.LFB2401:
	.cfi_startproc
	endbr64
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	mov	QWORD PTR -24[rbp], rdi
	mov	DWORD PTR -12[rbp], 0
	mov	QWORD PTR -8[rbp], 1
	jmp	.L2
.L3:
	sal	QWORD PTR -8[rbp]
	add	DWORD PTR -12[rbp], 1
.L2:
	mov	rax, QWORD PTR -8[rbp]
	cmp	rax, QWORD PTR -24[rbp]
	jl	.L3
	mov	eax, DWORD PTR -12[rbp]
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2401:
	.size	find_nearest_power, .-find_nearest_power
	.type	on_dialog_response, @function
on_dialog_response:
.LFB2402:
	.cfi_startproc
	endbr64
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 32
	mov	QWORD PTR -8[rbp], rdi
	mov	DWORD PTR -12[rbp], esi
	mov	QWORD PTR -24[rbp], rdx
	call	gtk_widget_get_type@PLT
	mov	rdx, rax
	mov	rax, QWORD PTR -8[rbp]
	mov	rsi, rdx
	mov	rdi, rax
	call	g_type_check_instance_cast@PLT
	mov	rdi, rax
	call	gtk_widget_destroy@PLT
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2402:
	.size	on_dialog_response, .-on_dialog_response
	.section	.rodata
	.align 8
.LC0:
	.string	"\320\240\320\260\320\267\321\200\320\265\321\210\320\265\320\275\321\213 \321\202\320\276\320\273\321\214\320\272\320\276 \321\206\320\270\321\204\321\200\321\213!"
.LC1:
	.string	"response"
	.align 8
.LC2:
	.string	"\320\221\320\273\320\270\320\266\320\260\320\271\321\210\320\260\321\217 \321\201\321\202\320\265\320\277\320\265\320\275\321\214 \320\264\320\262\320\276\320\271\320\272\320\270: %d."
	.align 8
.LC3:
	.string	"\320\222\320\276\320\267\320\275\320\270\320\272\320\273\320\260 \320\276\321\210\320\270\320\261\320\272\320\260!"
	.text
	.type	calc_and_display_pow, @function
calc_and_display_pow:
.LFB2403:
	.cfi_startproc
	endbr64
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 80
	mov	QWORD PTR -72[rbp], rdi
	mov	QWORD PTR -80[rbp], rsi
	mov	rax, QWORD PTR fs:40
	mov	QWORD PTR -8[rbp], rax
	xor	eax, eax
	call	gtk_entry_get_type@PLT
	mov	rdx, rax
	mov	rax, QWORD PTR -80[rbp]
	mov	rsi, rdx
	mov	rdi, rax
	call	g_type_check_instance_cast@PLT
	mov	rdi, rax
	call	gtk_entry_get_text@PLT
	mov	QWORD PTR -48[rbp], rax
	cmp	QWORD PTR -48[rbp], 0
	je	.L7
	mov	rax, QWORD PTR -48[rbp]
	movzx	eax, BYTE PTR [rax]
	test	al, al
	je	.L7
	lea	rcx, -56[rbp]
	mov	rax, QWORD PTR -48[rbp]
	mov	edx, 10
	mov	rsi, rcx
	mov	rdi, rax
	call	strtoll@PLT
	mov	QWORD PTR -40[rbp], rax
	mov	rax, QWORD PTR -56[rbp]
	movzx	eax, BYTE PTR [rax]
	test	al, al
	je	.L8
	lea	r8, .LC0[rip]
	mov	ecx, 1
	mov	edx, 3
	mov	esi, 1
	mov	edi, 0
	mov	eax, 0
	call	gtk_message_dialog_new@PLT
	mov	QWORD PTR -24[rbp], rax
	mov	rdx, QWORD PTR -24[rbp]
	mov	rax, QWORD PTR -24[rbp]
	mov	r9d, 0
	mov	r8d, 0
	mov	rcx, rdx
	lea	rdx, on_dialog_response[rip]
	lea	rsi, .LC1[rip]
	mov	rdi, rax
	call	g_signal_connect_data@PLT
	mov	rax, QWORD PTR -24[rbp]
	mov	rdi, rax
	call	gtk_widget_show_all@PLT
	jmp	.L6
.L8:
	mov	rax, QWORD PTR -40[rbp]
	mov	rdi, rax
	call	find_nearest_power
	mov	DWORD PTR -60[rbp], eax
	mov	eax, DWORD PTR -60[rbp]
	mov	r9d, eax
	lea	r8, .LC2[rip]
	mov	ecx, 1
	mov	edx, 0
	mov	esi, 1
	mov	edi, 0
	mov	eax, 0
	call	gtk_message_dialog_new@PLT
	mov	QWORD PTR -32[rbp], rax
	mov	rdx, QWORD PTR -32[rbp]
	mov	rax, QWORD PTR -32[rbp]
	mov	r9d, 0
	mov	r8d, 0
	mov	rcx, rdx
	lea	rdx, on_dialog_response[rip]
	lea	rsi, .LC1[rip]
	mov	rdi, rax
	call	g_signal_connect_data@PLT
	mov	rax, QWORD PTR -32[rbp]
	mov	rdi, rax
	call	gtk_widget_show_all@PLT
	jmp	.L6
.L7:
	lea	r8, .LC3[rip]
	mov	ecx, 1
	mov	edx, 3
	mov	esi, 1
	mov	edi, 0
	mov	eax, 0
	call	gtk_message_dialog_new@PLT
	mov	QWORD PTR -16[rbp], rax
	mov	rdx, QWORD PTR -16[rbp]
	mov	rax, QWORD PTR -16[rbp]
	mov	r9d, 0
	mov	r8d, 0
	mov	rcx, rdx
	lea	rdx, on_dialog_response[rip]
	lea	rsi, .LC1[rip]
	mov	rdi, rax
	call	g_signal_connect_data@PLT
	mov	rax, QWORD PTR -16[rbp]
	mov	rdi, rax
	call	gtk_widget_show_all@PLT
	nop
.L6:
	mov	rax, QWORD PTR -8[rbp]
	sub	rax, QWORD PTR fs:40
	je	.L10
	call	__stack_chk_fail@PLT
.L10:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2403:
	.size	calc_and_display_pow, .-calc_and_display_pow
	.section	.rodata
.LC4:
	.string	"Window"
.LC5:
	.string	"destroy"
	.align 8
.LC6:
	.string	"\320\222\321\213\321\207\320\270\321\201\320\273\320\270\321\202\321\214 \321\201\321\202\320\265\320\277\320\265\320\275\321\214"
.LC7:
	.string	"clicked"
	.text
	.type	activate, @function
activate:
.LFB2404:
	.cfi_startproc
	endbr64
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 64
	mov	QWORD PTR -56[rbp], rdi
	mov	QWORD PTR -64[rbp], rsi
	mov	rax, QWORD PTR fs:40
	mov	QWORD PTR -8[rbp], rax
	xor	eax, eax
	mov	rax, QWORD PTR -56[rbp]
	mov	rdi, rax
	call	gtk_application_window_new@PLT
	mov	QWORD PTR -40[rbp], rax
	call	gtk_window_get_type@PLT
	mov	rdx, rax
	mov	rax, QWORD PTR -40[rbp]
	mov	rsi, rdx
	mov	rdi, rax
	call	g_type_check_instance_cast@PLT
	mov	rdx, rax
	lea	rax, .LC4[rip]
	mov	rsi, rax
	mov	rdi, rdx
	call	gtk_window_set_title@PLT
	call	gtk_window_get_type@PLT
	mov	rdx, rax
	mov	rax, QWORD PTR -40[rbp]
	mov	rsi, rdx
	mov	rdi, rax
	call	g_type_check_instance_cast@PLT
	mov	edx, 200
	mov	esi, 200
	mov	rdi, rax
	call	gtk_window_set_default_size@PLT
	mov	rax, QWORD PTR -40[rbp]
	lea	rdx, -40[rbp]
	mov	r9d, 0
	mov	r8d, 0
	mov	rcx, rdx
	mov	rdx, QWORD PTR gtk_widget_destroyed@GOTPCREL[rip]
	lea	rsi, .LC5[rip]
	mov	rdi, rax
	call	g_signal_connect_data@PLT
	call	gtk_grid_new@PLT
	mov	QWORD PTR -32[rbp], rax
	lea	rax, .LC6[rip]
	mov	rdi, rax
	call	gtk_button_new_with_label@PLT
	mov	QWORD PTR -24[rbp], rax
	call	gtk_entry_new@PLT
	mov	QWORD PTR -16[rbp], rax
	call	gtk_container_get_type@PLT
	mov	rdx, rax
	mov	rax, QWORD PTR -40[rbp]
	mov	rsi, rdx
	mov	rdi, rax
	call	g_type_check_instance_cast@PLT
	mov	rdx, rax
	mov	rax, QWORD PTR -32[rbp]
	mov	rsi, rax
	mov	rdi, rdx
	call	gtk_container_add@PLT
	call	gtk_grid_get_type@PLT
	mov	rdx, rax
	mov	rax, QWORD PTR -32[rbp]
	mov	rsi, rdx
	mov	rdi, rax
	call	g_type_check_instance_cast@PLT
	mov	rdi, rax
	mov	rax, QWORD PTR -24[rbp]
	mov	r9d, 1
	mov	r8d, 1
	mov	ecx, 0
	mov	edx, 0
	mov	rsi, rax
	call	gtk_grid_attach@PLT
	call	gtk_grid_get_type@PLT
	mov	rdx, rax
	mov	rax, QWORD PTR -32[rbp]
	mov	rsi, rdx
	mov	rdi, rax
	call	g_type_check_instance_cast@PLT
	mov	rdi, rax
	mov	rax, QWORD PTR -16[rbp]
	mov	r9d, 1
	mov	r8d, 1
	mov	ecx, 1
	mov	edx, 0
	mov	rsi, rax
	call	gtk_grid_attach@PLT
	mov	rdx, QWORD PTR -16[rbp]
	mov	rax, QWORD PTR -24[rbp]
	mov	r9d, 0
	mov	r8d, 0
	mov	rcx, rdx
	lea	rdx, calc_and_display_pow[rip]
	lea	rsi, .LC7[rip]
	mov	rdi, rax
	call	g_signal_connect_data@PLT
	mov	rax, QWORD PTR -40[rbp]
	mov	rdi, rax
	call	gtk_widget_show_all@PLT
	nop
	mov	rax, QWORD PTR -8[rbp]
	sub	rax, QWORD PTR fs:40
	je	.L12
	call	__stack_chk_fail@PLT
.L12:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2404:
	.size	activate, .-activate
	.section	.rodata
.LC8:
	.string	"org.gtk.example"
.LC9:
	.string	"activate"
	.text
	.globl	main
	.type	main, @function
main:
.LFB2405:
	.cfi_startproc
	endbr64
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 32
	mov	DWORD PTR -20[rbp], edi
	mov	QWORD PTR -32[rbp], rsi
	mov	esi, 0
	lea	rax, .LC8[rip]
	mov	rdi, rax
	call	gtk_application_new@PLT
	mov	QWORD PTR -8[rbp], rax
	mov	rax, QWORD PTR -8[rbp]
	mov	r9d, 0
	mov	r8d, 0
	mov	ecx, 0
	lea	rdx, activate[rip]
	lea	rsi, .LC9[rip]
	mov	rdi, rax
	call	g_signal_connect_data@PLT
	call	g_application_get_type@PLT
	mov	rdx, rax
	mov	rax, QWORD PTR -8[rbp]
	mov	rsi, rdx
	mov	rdi, rax
	call	g_type_check_instance_cast@PLT
	mov	rcx, rax
	mov	rdx, QWORD PTR -32[rbp]
	mov	eax, DWORD PTR -20[rbp]
	mov	esi, eax
	mov	rdi, rcx
	call	g_application_run@PLT
	mov	DWORD PTR -12[rbp], eax
	mov	rax, QWORD PTR -8[rbp]
	mov	rdi, rax
	call	g_object_unref@PLT
	mov	eax, DWORD PTR -12[rbp]
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2405:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 13.3.0-6ubuntu2~24.04) 13.3.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	1f - 0f
	.long	4f - 1f
	.long	5
0:
	.string	"GNU"
1:
	.align 8
	.long	0xc0000002
	.long	3f - 2f
2:
	.long	0x3
3:
	.align 8
4:
