FASM := fasm

SRCS := $(filter-out ./test.asm, $(wildcard ./*.asm))
OBJS := $(SRCS:%.asm=%.o)

all: main.exe test.exe

main.exe: $(OBJS)
	gcc -o $@ $^

test.exe: test.o
	gcc -o $@ $^

%.o: %.asm
	$(FASM) $< $@

clean:
	$(RM) -v ./*.o ./*.exe
