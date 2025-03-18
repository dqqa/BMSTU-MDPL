FASM := fasm

all: main test

main: main.o
	gcc -o $@ $^

main.o: main.asm
	$(FASM) $< $@

test: test.o
	gcc -o $@ $^

test.o: test.asm
	$(FASM) $< $@

clean:
	$(RM) -v ./*.o main test
