NASM := nasm
CC := gcc

CFLAGS := -Wall -Wextra

all: task_01.exe task_02.exe task_03.exe

task_01.exe: main.c
	$(CC) $(CFLAGS) $^ -o $@

task_02.exe: task_02.asm
	$(NASM) -f elf32 $^ -g
	$(CC) -m32 task_02.o -o $@

clean:
	$(RM) ./*.exe ./*.o
