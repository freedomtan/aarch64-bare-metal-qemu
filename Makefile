osname := $(shell uname -s)

#use Android toolchain on OS X
#use linaro bare metal toolchain on linux
ifeq ($(osname), Darwin)
CROSS_PREFIX=aarch64-linux-android-
else
CROSS_PREFIX=aarch64-none-elf-
endif

all: test64.elf

test64.o: test64.c
	$(CROSS_PREFIX)gcc -c $< -o $@

startup64.o: startup64.s
	$(CROSS_PREFIX)as -c $< -o $@

test64.elf: test64.o startup64.o
	$(CROSS_PREFIX)ld -Ttest64.ld $^ -o $@

clean:
	rm test64.elf startup64.o test64.o
