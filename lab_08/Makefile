CC := gcc
NASM := nasm

SRCS := $(wildcard ./*.asm)
OBJS := $(SRCS:%.asm=%.o)

EXE := main.exe

# CFLAGS := -Wall -Wextra -Wpedantic -std=c99 $(shell pkg-config --cflags gtk+-3.0) -g
LDFLAGS := $(shell pkg-config --libs gtk+-3.0)
ASMFLAGS := -f elf64 -g

%.o: %.asm
	$(NASM) $(ASMFLAGS) $^ -o $@

$(EXE): $(OBJS)
	$(CC) $^ -o $@ $(LDFLAGS)

.PHONY: clean all

clean:
	$(RM) -v ./*.o ./*.exe
