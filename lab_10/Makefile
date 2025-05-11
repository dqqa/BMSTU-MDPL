NASM := nasm
CC := gcc

# CFLAGS := -Wall -Wextra
CFLAGS := -Wall -Wextra -mno-avx -mno-sse -m32 -mfpmath=387

all: task_01.exe task_02.exe task_03.exe

task_01.exe: main.c
	$(CC) $(CFLAGS) $^ -o $@

task_02.exe: task_02.asm
	$(NASM) -f elf32 $^ -g
	$(CC) -no-pie -m32 task_02.o -o $@

task_03.exe: task_03.asm
	$(NASM) -f elf32 $^ -g
	$(CC) -no-pie -m32 task_03.o -o $@

clean:
	$(RM) ./*.exe ./*.o
