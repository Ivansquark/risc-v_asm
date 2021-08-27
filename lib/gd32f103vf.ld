OUTPUT_ARCH( "riscv" )
ENTRY( reset_handler )

MEMORY{
    FLASH (rx) : ORIGIN = 0x08000000, LENGTH = 128K
    RAM (rwx) : ORIGIN = 0x20000000, LENGTH = 32K
}

SECTIONS{
    .vector_table :
    {
        KEEP (*(SORT_NONE(.vector_table)))
    } >FLASH

    .text : {
        . = ALIGN(4);
        *(.rodata .rodata.*)  
        *(.srodata .srodata.*)
        *(.text*)
        /*
        *(.rodata*)
        */        
    } > FLASH
    . = ALIGN(4);
    PROVIDE (__etext = .);
    PROVIDE (_etext = .);
    PROVIDE (etext = .);

    _sidata = .;
    .data : AT( _sidata ) {
        _sdata = .;
        *(.data*)
        . = ALIGN(4);
        _edata = .;
    } > RAM

    .bss : {
        _sbss = .;
        *(.bss*)
        . = ALIGN(4);
        _ebss = .;
    } > RAM
}


PROVIDE(_stack_end = ORIGIN(RAM) + LENGTH(RAM));
PROVIDE(_data_load = LOADADDR(.data));