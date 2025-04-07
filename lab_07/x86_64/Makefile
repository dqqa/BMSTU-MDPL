NASM := nasm
CC := gcc

SRCS := main.c my_strcpy.asm
OBJS := main.o my_strcpy.o

EXE := lab_07.exe

ASMFLAGS := -f elf64 -g
CFLAGS := -ggdb

$(EXE): $(OBJS)
	$(CC) -o $@ $^ $(LDFLAGS)

%.o: %.asm
	$(NASM) $(ASMFLAGS) $^ -o $@

%.o: %.c
	$(CC) $(CFLAGS) -c $^ -o $@

clean:
	$(RM) -v ./*.o ./*.exe
