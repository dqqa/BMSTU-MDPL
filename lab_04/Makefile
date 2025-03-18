FASM := fasm

all: main.exe test.exe

main.exe: main.o
	gcc -o $@ $^

main.o: main.asm
	$(FASM) $< $@

test.exe: test.o
	gcc -o $@ $^

test.o: test.asm
	$(FASM) $< $@

clean:
	$(RM) -v ./*.o ./*.exe
