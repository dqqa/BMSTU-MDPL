NASM := nasm

SRCS := $(wildcard ./*.asm)
OBJS := $(SRCS:%.asm=%.o)

ASMFLAGS := -f elf64

all: main.exe

main.exe: $(OBJS)
	gcc -o $@ $^

debug: ASMFLAGS += -g
debug: main.exe

%.o: %.asm
	$(NASM) $(ASMFLAGS) $^ -o $@

PHONY: clean debug

clean:
	$(RM) -v ./*.exe ./*.o
