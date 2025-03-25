
./main.exe:     file format elf64-x86-64


Disassembly of section .init:

0000000000001000 <_init>:
    1000:	f3 0f 1e fa          	endbr64
    1004:	48 83 ec 08          	sub    rsp,0x8
    1008:	48 8b 05 d9 2f 00 00 	mov    rax,QWORD PTR [rip+0x2fd9]        # 3fe8 <__gmon_start__@Base>
    100f:	48 85 c0             	test   rax,rax
    1012:	74 02                	je     1016 <_init+0x16>
    1014:	ff d0                	call   rax
    1016:	48 83 c4 08          	add    rsp,0x8
    101a:	c3                   	ret

Disassembly of section .plt:

0000000000001020 <printf@plt-0x10>:
    1020:	ff 35 8a 2f 00 00    	push   QWORD PTR [rip+0x2f8a]        # 3fb0 <_GLOBAL_OFFSET_TABLE_+0x8>
    1026:	ff 25 8c 2f 00 00    	jmp    QWORD PTR [rip+0x2f8c]        # 3fb8 <_GLOBAL_OFFSET_TABLE_+0x10>
    102c:	0f 1f 40 00          	nop    DWORD PTR [rax+0x0]

0000000000001030 <printf@plt>:
    1030:	ff 25 8a 2f 00 00    	jmp    QWORD PTR [rip+0x2f8a]        # 3fc0 <printf@GLIBC_2.2.5>
    1036:	68 00 00 00 00       	push   0x0
    103b:	e9 e0 ff ff ff       	jmp    1020 <_init+0x20>

0000000000001040 <scanf@plt>:
    1040:	ff 25 82 2f 00 00    	jmp    QWORD PTR [rip+0x2f82]        # 3fc8 <scanf@GLIBC_2.2.5>
    1046:	68 01 00 00 00       	push   0x1
    104b:	e9 d0 ff ff ff       	jmp    1020 <_init+0x20>

0000000000001050 <exit@plt>:
    1050:	ff 25 7a 2f 00 00    	jmp    QWORD PTR [rip+0x2f7a]        # 3fd0 <exit@GLIBC_2.2.5>
    1056:	68 02 00 00 00       	push   0x2
    105b:	e9 c0 ff ff ff       	jmp    1020 <_init+0x20>

Disassembly of section .plt.got:

0000000000001060 <__cxa_finalize@plt>:
    1060:	ff 25 92 2f 00 00    	jmp    QWORD PTR [rip+0x2f92]        # 3ff8 <__cxa_finalize@GLIBC_2.2.5>
    1066:	66 90                	xchg   ax,ax

Disassembly of section .text:

0000000000001070 <_start>:
    1070:	f3 0f 1e fa          	endbr64
    1074:	31 ed                	xor    ebp,ebp
    1076:	49 89 d1             	mov    r9,rdx
    1079:	5e                   	pop    rsi
    107a:	48 89 e2             	mov    rdx,rsp
    107d:	48 83 e4 f0          	and    rsp,0xfffffffffffffff0
    1081:	50                   	push   rax
    1082:	54                   	push   rsp
    1083:	45 31 c0             	xor    r8d,r8d
    1086:	31 c9                	xor    ecx,ecx
    1088:	48 8d 3d 21 01 00 00 	lea    rdi,[rip+0x121]        # 11b0 <main>
    108f:	ff 15 43 2f 00 00    	call   QWORD PTR [rip+0x2f43]        # 3fd8 <__libc_start_main@GLIBC_2.34>
    1095:	f4                   	hlt
    1096:	66 2e 0f 1f 84 00 00 	cs nop WORD PTR [rax+rax*1+0x0]
    109d:	00 00 00 

00000000000010a0 <deregister_tm_clones>:
    10a0:	48 8d 3d 81 2f 00 00 	lea    rdi,[rip+0x2f81]        # 4028 <__TMC_END__>
    10a7:	48 8d 05 7a 2f 00 00 	lea    rax,[rip+0x2f7a]        # 4028 <__TMC_END__>
    10ae:	48 39 f8             	cmp    rax,rdi
    10b1:	74 15                	je     10c8 <deregister_tm_clones+0x28>
    10b3:	48 8b 05 26 2f 00 00 	mov    rax,QWORD PTR [rip+0x2f26]        # 3fe0 <_ITM_deregisterTMCloneTable@Base>
    10ba:	48 85 c0             	test   rax,rax
    10bd:	74 09                	je     10c8 <deregister_tm_clones+0x28>
    10bf:	ff e0                	jmp    rax
    10c1:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]
    10c8:	c3                   	ret
    10c9:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]

00000000000010d0 <register_tm_clones>:
    10d0:	48 8d 3d 51 2f 00 00 	lea    rdi,[rip+0x2f51]        # 4028 <__TMC_END__>
    10d7:	48 8d 35 4a 2f 00 00 	lea    rsi,[rip+0x2f4a]        # 4028 <__TMC_END__>
    10de:	48 29 fe             	sub    rsi,rdi
    10e1:	48 89 f0             	mov    rax,rsi
    10e4:	48 c1 ee 3f          	shr    rsi,0x3f
    10e8:	48 c1 f8 03          	sar    rax,0x3
    10ec:	48 01 c6             	add    rsi,rax
    10ef:	48 d1 fe             	sar    rsi,1
    10f2:	74 14                	je     1108 <register_tm_clones+0x38>
    10f4:	48 8b 05 f5 2e 00 00 	mov    rax,QWORD PTR [rip+0x2ef5]        # 3ff0 <_ITM_registerTMCloneTable@Base>
    10fb:	48 85 c0             	test   rax,rax
    10fe:	74 08                	je     1108 <register_tm_clones+0x38>
    1100:	ff e0                	jmp    rax
    1102:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]
    1108:	c3                   	ret
    1109:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]

0000000000001110 <__do_global_dtors_aux>:
    1110:	f3 0f 1e fa          	endbr64
    1114:	80 3d 0d 2f 00 00 00 	cmp    BYTE PTR [rip+0x2f0d],0x0        # 4028 <__TMC_END__>
    111b:	75 2b                	jne    1148 <__do_global_dtors_aux+0x38>
    111d:	55                   	push   rbp
    111e:	48 83 3d d2 2e 00 00 	cmp    QWORD PTR [rip+0x2ed2],0x0        # 3ff8 <__cxa_finalize@GLIBC_2.2.5>
    1125:	00 
    1126:	48 89 e5             	mov    rbp,rsp
    1129:	74 0c                	je     1137 <__do_global_dtors_aux+0x27>
    112b:	48 8b 3d d6 2e 00 00 	mov    rdi,QWORD PTR [rip+0x2ed6]        # 4008 <__dso_handle>
    1132:	e8 29 ff ff ff       	call   1060 <__cxa_finalize@plt>
    1137:	e8 64 ff ff ff       	call   10a0 <deregister_tm_clones>
    113c:	c6 05 e5 2e 00 00 01 	mov    BYTE PTR [rip+0x2ee5],0x1        # 4028 <__TMC_END__>
    1143:	5d                   	pop    rbp
    1144:	c3                   	ret
    1145:	0f 1f 00             	nop    DWORD PTR [rax]
    1148:	c3                   	ret
    1149:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]

0000000000001150 <frame_dummy>:
    1150:	f3 0f 1e fa          	endbr64
    1154:	e9 77 ff ff ff       	jmp    10d0 <register_tm_clones>
    1159:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]

0000000000001160 <panic>:
    1160:	55                   	push   rbp
    1161:	48 89 e5             	mov    rbp,rsp
    1164:	48 83 ec 10          	sub    rsp,0x10
    1168:	48 8d 3d 95 0e 00 00 	lea    rdi,[rip+0xe95]        # 2004 <panic_msg>
    116f:	e8 bc fe ff ff       	call   1030 <printf@plt>
    1174:	e8 d7 fe ff ff       	call   1050 <exit@plt>
    1179:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]

0000000000001180 <input_hexadecimal>:
    1180:	55                   	push   rbp
    1181:	48 89 e5             	mov    rbp,rsp
    1184:	48 83 ec 10          	sub    rsp,0x10
    1188:	e8 a3 fe ff ff       	call   1030 <printf@plt>
    118d:	48 8d 3d 78 0e 00 00 	lea    rdi,[rip+0xe78]        # 200c <num_input_fmt>
    1194:	48 8d 75 fe          	lea    rsi,[rbp-0x2]
    1198:	e8 a3 fe ff ff       	call   1040 <scanf@plt>
    119d:	48 85 c0             	test   rax,rax
    11a0:	75 05                	jne    11a7 <input_hexadecimal.ok>
    11a2:	e8 b9 ff ff ff       	call   1160 <panic>

00000000000011a7 <input_hexadecimal.ok>:
    11a7:	66 8b 45 fe          	mov    ax,WORD PTR [rbp-0x2]
    11ab:	48 89 ec             	mov    rsp,rbp
    11ae:	5d                   	pop    rbp
    11af:	c3                   	ret

00000000000011b0 <main>:
    11b0:	55                   	push   rbp
    11b1:	48 89 e5             	mov    rbp,rsp
    11b4:	48 83 ec 10          	sub    rsp,0x10
    11b8:	48 8d 3d 51 0e 00 00 	lea    rdi,[rip+0xe51]        # 2010 <msg>
    11bf:	e8 bc ff ff ff       	call   1180 <input_hexadecimal>
    11c4:	66 89 45 fe          	mov    WORD PTR [rbp-0x2],ax

00000000000011c8 <main.loop_begin>:
    11c8:	48 8d 3d 50 0e 00 00 	lea    rdi,[rip+0xe50]        # 201f <menu>
    11cf:	e8 5c fe ff ff       	call   1030 <printf@plt>
    11d4:	48 8d 3d e2 0e 00 00 	lea    rdi,[rip+0xee2]        # 20bd <menu_opt_scan_fmt>
    11db:	48 8d 75 fa          	lea    rsi,[rbp-0x6]
    11df:	e8 5c fe ff ff       	call   1040 <scanf@plt>
    11e4:	48 85 c0             	test   rax,rax
    11e7:	75 05                	jne    11ee <main.ok>
    11e9:	e8 72 ff ff ff       	call   1160 <panic>

00000000000011ee <main.ok>:
    11ee:	83 7d fa 00          	cmp    DWORD PTR [rbp-0x6],0x0
    11f2:	7f 05                	jg     11f9 <main.ok1>
    11f4:	e8 67 ff ff ff       	call   1160 <panic>

00000000000011f9 <main.ok1>:
    11f9:	83 7d fa 04          	cmp    DWORD PTR [rbp-0x6],0x4
    11fd:	7e 05                	jle    1204 <main.ok2>
    11ff:	e8 5c ff ff ff       	call   1160 <panic>

0000000000001204 <main.ok2>:
    1204:	83 7d fa 04          	cmp    DWORD PTR [rbp-0x6],0x4
    1208:	74 2e                	je     1238 <main.loop_end>
    120a:	ff 4d fa             	dec    DWORD PTR [rbp-0x6]
    120d:	8b 45 fa             	mov    eax,DWORD PTR [rbp-0x6]
    1210:	66 bb 08 00          	mov    bx,0x8
    1214:	66 f7 e3             	mul    bx
    1217:	48 89 c3             	mov    rbx,rax
    121a:	48 8d 05 ef 2d 00 00 	lea    rax,[rip+0x2def]        # 4010 <ptr_table>
    1221:	48 01 d8             	add    rax,rbx
    1224:	66 8b 7d fe          	mov    di,WORD PTR [rbp-0x2]
    1228:	ff 10                	call   QWORD PTR [rax]
    122a:	48 8d 3d cd 0e 00 00 	lea    rdi,[rip+0xecd]        # 20fe <newline>
    1231:	e8 fa fd ff ff       	call   1030 <printf@plt>
    1236:	eb 90                	jmp    11c8 <main.loop_begin>

0000000000001238 <main.loop_end>:
    1238:	48 31 c0             	xor    rax,rax
    123b:	48 89 ec             	mov    rsp,rbp
    123e:	5d                   	pop    rbp
    123f:	c3                   	ret

0000000000001240 <print_max_power_of_2>:
    1240:	55                   	push   rbp
    1241:	48 89 e5             	mov    rbp,rsp
    1244:	48 83 ec 10          	sub    rsp,0x10
    1248:	66 c7 45 fe 0f 00    	mov    WORD PTR [rbp-0x2],0xf

000000000000124e <print_max_power_of_2.loop_begin>:
    124e:	66 83 7d fe 00       	cmp    WORD PTR [rbp-0x2],0x0
    1253:	7c 1f                	jl     1274 <print_max_power_of_2.loop_end>
    1255:	66 89 f8             	mov    ax,di
    1258:	66 8b 4d fe          	mov    cx,WORD PTR [rbp-0x2]
    125c:	66 bb 01 00          	mov    bx,0x1
    1260:	66 d3 e3             	shl    bx,cl
    1263:	66 31 d2             	xor    dx,dx
    1266:	66 f7 f3             	div    bx
    1269:	66 85 d2             	test   dx,dx
    126c:	74 06                	je     1274 <print_max_power_of_2.loop_end>
    126e:	66 ff 4d fe          	dec    WORD PTR [rbp-0x2]
    1272:	eb da                	jmp    124e <print_max_power_of_2.loop_begin>

0000000000001274 <print_max_power_of_2.loop_end>:
    1274:	48 8d 3d 85 0e 00 00 	lea    rdi,[rip+0xe85]        # 2100 <message>
    127b:	66 8b 75 fe          	mov    si,WORD PTR [rbp-0x2]
    127f:	e8 ac fd ff ff       	call   1030 <printf@plt>
    1284:	48 89 ec             	mov    rsp,rbp
    1287:	5d                   	pop    rbp
    1288:	c3                   	ret
    1289:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]

0000000000001290 <print_signed_decimal>:
    1290:	55                   	push   rbp
    1291:	48 89 e5             	mov    rbp,rsp
    1294:	48 83 ec 10          	sub    rsp,0x10
    1298:	66 81 e7 ff 00       	and    di,0xff
    129d:	40 88 fe             	mov    sil,dil
    12a0:	48 8d 3d 71 0e 00 00 	lea    rdi,[rip+0xe71]        # 2118 <print_8bit_fmt>
    12a7:	e8 84 fd ff ff       	call   1030 <printf@plt>
    12ac:	48 89 ec             	mov    rsp,rbp
    12af:	5d                   	pop    rbp
    12b0:	c3                   	ret
    12b1:	66 2e 0f 1f 84 00 00 	cs nop WORD PTR [rax+rax*1+0x0]
    12b8:	00 00 00 
    12bb:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]

00000000000012c0 <print_unsigned_binary>:
    12c0:	55                   	push   rbp
    12c1:	48 89 e5             	mov    rbp,rsp
    12c4:	48 83 ec 10          	sub    rsp,0x10
    12c8:	66 c7 45 fe 0f 00    	mov    WORD PTR [rbp-0x2],0xf
    12ce:	66 89 7d fc          	mov    WORD PTR [rbp-0x4],di

00000000000012d2 <print_unsigned_binary.loop>:
    12d2:	66 83 7d fe 00       	cmp    WORD PTR [rbp-0x2],0x0
    12d7:	7c 30                	jl     1309 <print_unsigned_binary.endloop>
    12d9:	66 b8 01 00          	mov    ax,0x1
    12dd:	66 8b 4d fe          	mov    cx,WORD PTR [rbp-0x2]
    12e1:	66 d3 e0             	shl    ax,cl
    12e4:	66 8b 5d fc          	mov    bx,WORD PTR [rbp-0x4]
    12e8:	66 85 c3             	test   bx,ax
    12eb:	74 07                	je     12f4 <print_unsigned_binary.zero>
    12ed:	be 01 00 00 00       	mov    esi,0x1
    12f2:	eb 03                	jmp    12f7 <print_unsigned_binary.print_bit>

00000000000012f4 <print_unsigned_binary.zero>:
    12f4:	48 31 f6             	xor    rsi,rsi

00000000000012f7 <print_unsigned_binary.print_bit>:
    12f7:	48 8d 3d 22 0e 00 00 	lea    rdi,[rip+0xe22]        # 2120 <bit_output_fmt>
    12fe:	e8 2d fd ff ff       	call   1030 <printf@plt>
    1303:	66 ff 4d fe          	dec    WORD PTR [rbp-0x2]
    1307:	eb c9                	jmp    12d2 <print_unsigned_binary.loop>

0000000000001309 <print_unsigned_binary.endloop>:
    1309:	48 8d 3d 13 0e 00 00 	lea    rdi,[rip+0xe13]        # 2123 <newline>
    1310:	e8 1b fd ff ff       	call   1030 <printf@plt>
    1315:	48 31 c0             	xor    rax,rax
    1318:	48 89 ec             	mov    rsp,rbp
    131b:	5d                   	pop    rbp
    131c:	c3                   	ret

Disassembly of section .fini:

0000000000001320 <_fini>:
    1320:	f3 0f 1e fa          	endbr64
    1324:	48 83 ec 08          	sub    rsp,0x8
    1328:	48 83 c4 08          	add    rsp,0x8
    132c:	c3                   	ret
