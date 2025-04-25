CC := gcc

SRCS := $(wildcard ./*.c)
OBJS := $(SRCS:%.c=%.o)

CFLAGS := -Wall -Werror -Wextra

EXE := patcher.exe

$(EXE): $(OBJS)
	$(CC) $^ -o $@

%.o: %.c
	$(CC) $(CFLAGS) -c $^ -o $@

.PHONY: clean

clean:
	$(RM) -v ./patcher.exe ./*.o
