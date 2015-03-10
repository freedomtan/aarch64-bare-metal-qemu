# aarch64-bare-metal-qemu
simple aarch64 bare metal 'Hello World' on qemu

Since I didn't write bare metal program on ARMv8/aarch64 before, I'll just do one.

1. starting from https://balau82.wordpress.com/2010/02/28/hello-world-for-bare-metal-arm-using-qemu/ seems a good idea
2. the toolchain is different, we need aarch64 cross compile toolchain. I think both linux and bare metal toolchains work for my testing purpose. However, I'll use bare metal one from linaro (http://releases.linaro.org/14.11/components/toolchain/binaries/aarch64-none-elf/gcc-linaro-4.9-2014.11-x86_64_aarch64-elf.tar.xz) 
3. startup.s needs a bit tweek. We cannot ldr a value to the stack pointer (sp) directly. So I load the starting address of stack to x30, then load x30 into sp.
4. my modified startup.s is named [startup64.s](startup64.s) which is compiled into startup64.o by 'aarch64-none-elf-as -g startup64.s -o startup64.o'
5. One of the working aarch64 targets of qemu is virt, a look into qemu's [hw/arm/virt.c](http://git.qemu.org/?p=qemu.git;a=blob_plain;f=hw/arm/virt.c;hb=HEAD) shows that the memory mapped UART0 is located at 0x0900000. So the UART0DR in test.c should be changed to 0x09000000. My modified test.c is called [test64.c](test64.c), which is compiled into .o by 'aarch64-none-elf-gcc -c -g test64.c -o test64.o'
6. The address to load the program to should be changed too. '0x10000' is not valid RAM or ROM address for -M virt. According to virt.c, '0x40000000' is OK to use. So my linker script is modified and named [test64.ld](test64.ld)
7. I use 'aarch64-none-elf-ld -T test64.ld test64.o startup64.o -o test64.elf' to generate test64.elf
8. That's it. Since qemu can load elf directly now. We can use 'qemu-system-aarch64 -M virt -cpu cortex-a57 -nographic  -kernel test64.elf' to run the elf and see 'Hello Wolrd!'.
