PHONY: all, clean, load

SRC = src/
BLD = build/
LIB = lib/
INC = -Iinc/

CC = riscv64-unknown-elf-gcc
AS = riscv64-unknown-elf-as
OBJCOPY = riscv64-unknown-elf-objcopy  
OBJDUMP = riscv64-unknown-elf-objdump
CFLAGS = -g -O0 -march=rv32imac -mabi=ilp32 -mcmodel=medany -nostdlib  
#-mcmodel=medany
LFLAGS = -T$(LIB)gd32f103vf.ld -Xlinker -Map=$(BLD)prog.map
ASFLAGS = -march=rv32imac -mabi=ilp32 

all: $(BLD)prog.elf $(BLD)prog.bin $(BLD)prog.lst $(BLD)prog.hex
$(BLD)prog.hex: $(BLD)prog.elf
	$(OBJCOPY) -O ihex $(BLD)prog.elf $(BLD)prog.hex
$(BLD)prog.bin: $(BLD)prog.elf
	$(OBJCOPY) -O binary $(BLD)prog.elf $(BLD)prog.bin
$(BLD)prog.lst: $(BLD)prog.elf
	$(OBJDUMP) -dr -S $(BLD)prog.elf > $(BLD)prog.lst

#$(BLD)main.elf: $(SRC)start.s
#	$(CC) $(SRC)start.s -o $(BLD)main.elf $(CFLAGS) $(LFLAGS)
$(BLD)prog.elf: $(BLD)main.o $(BLD)startup.o
	$(CC)   $(BLD)startup.o $(BLD)main.o $(LFLAGS) -o $(BLD)prog.elf $(CFLAGS) $(INC)
	@echo "********************  SIZE  **************************"
	@riscv64-unknown-elf-size $(BLD)prog.elf
	@echo "******************************************************"	
$(BLD)startup.o: $(SRC)startup.s
	$(AS) -c $(SRC)startup.s -o $(BLD)startup.o $(ASFLAGS)
	$(OBJDUMP) -dr -S $(BLD)startup.o > $(BLD)startup.lst
$(BLD)main.o: $(SRC)main.S
	$(CC) -c $(SRC)main.S -o $(BLD)main.o $(CFLAGS) $(INC)
	$(OBJDUMP) -dr -S $(BLD)main.o > $(BLD)main.lst

clean:
	rm -R build
	mkdir build	

load:
#	stm32flash /dev/ttyUSB0 -w $(BLD)main.bin
	dfu-util -a 0 -d 28e9:0189 -s 0x08000000 -D $(BLD)prog.bin

# ****  instruction to use dfu-util without sudo *******
# sudo nano /etc/udev/rules.d/99-particles.rules
# SUBSYSTEMS=="usb", ATTRS{idVendor}=="28e9", ATTRS{idProduct}=="0189", GROUP="plugdev", MODE="0666"
# *** checkout::::          dfu-util -l	