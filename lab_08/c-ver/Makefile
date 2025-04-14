CC := gcc

SRCS := $(wildcard ./*.c)
OBJS := $(SRCS:%.c=%.o)

EXE := main.exe

CFLAGS := -Wall -Wextra -Wpedantic -std=c99 $(shell pkg-config --cflags gtk+-3.0) -g
LDFLAGS := $(shell pkg-config --libs gtk+-3.0)

%.o: %.c
	$(CC) -c $^ $(CFLAGS) -o $@

$(EXE): $(OBJS)
	$(CC) $^ -o $@ $(LDFLAGS)

.PHONY: clean all

clean:
	$(RM) -v ./*.o ./*.exe
