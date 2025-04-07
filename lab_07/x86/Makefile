NASM := nasm
CC := gcc

SRCS := main.c my_strcpy.asm
OBJS := main.o my_strcpy.o

EXE := lab_07.exe

ASMFLAGS := -f elf32 -g
CFLAGS := -ggdb -m32
LDFLAGS := -m32

$(EXE): $(OBJS)
	$(CC) -o $@ $^ $(LDFLAGS)

%.o: %.asm
	$(NASM) $(ASMFLAGS) $^ -o $@

%.o: %.c
	$(CC) $(CFLAGS) -c $^ -o $@

clean:
	$(RM) -v ./*.o ./*.exe
