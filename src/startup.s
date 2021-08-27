##include "riscv_encoding.h" # must be .S but no .s and gcc exept as

# bumblebee core registers (for interrupt and Vector table)
.equ CSR_MMISC_CTL, 0x7d0
.equ CSR_MNVEC, 0x7C3
.equ CSR_MTVT,  0x307
.equ CSR_MTVT2, 0x7EC
.equ CSR_MTVEC, 0x305
.equ CSR_MCAUSE,0x342
.equ CSR_MEPC,  0x341
.equ CSR_MTVEC_ECLIC, 3
.equ CSR_MSTATUS, 0x300
.equ MSTATUS_MIE, (1<<3)

.global vtable
.type vtable, %object
.section .vector_table,"a",%progbits
.align 9
vtable:
  j reset_handler
  .align 2
  .word 0
  .word 0
  .word eclic_msip_handler  # Software interrupt
  .word 0
  .word 0
  .word 0
  .word eclic_mtip_handler  # Timer interrupt
  .word 0
  .word 0
  .word 0
  .word 0
  .word 0
  .word 0
  .word 0
  .word 0
  .word 0
  .word eclic_bwei_handler      
  .word eclic_pmovi_handler     
  .word watchdog_IRQn_handler
  .word LVD_IRQn_handler
  .word tamper_IRQn_handler
  .word RTC_IRQn_handler
  .word FMC_IRQn_handler
  .word RCU_IRQn_handler
  .word EXTI0_IRQn_handler
  .word EXTI1_IRQn_handler
  .word EXTI2_IRQn_handler
  .word EXTI3_IRQn_handler
  .word EXTI4_IRQn_handler
  .word DMA0_chan0_IRQn_handler
  .word DMA0_chan1_IRQn_handler
  .word DMA0_chan2_IRQn_handler
  .word DMA0_chan3_IRQn_handler
  .word DMA0_chan4_IRQn_handler
  .word DMA0_chan5_IRQn_handler
  .word DMA0_chan6_IRQn_handler
  .word ADC0_1_IRQn_handler
  .word CAN0_TX_IRQn_handler
  .word CAN0_RX0_IRQn_handler
  .word CAN0_RX1_IRQn_handler
  .word CAN0_EWMC_IRQn_handler
  .word EXTI5_9_IRQn_handler
  .word TIM0_break_IRQn_handler
  .word TIM0_update_IRQn_handler
  .word TIM0_trigger_commutation_IRQn_handler
  .word TIM0_channel_IRQn_handler
  .word TIM1_IRQn_handler
  .word TIM2_IRQn_handler
  .word TIM3_IRQn_handler
  .word I2C0_EV_IRQn_handler
  .word I2C0_ER_IRQn_handler
  .word I2C1_EV_IRQn_handler
  .word I2C1_ER_IRQn_handler
  .word SPI0_IRQn_handler
  .word SPI1_IRQn_handler
  .word USART0_IRQn_handler
  .word USART1_IRQn_handler
  .word USART2_IRQn_handler
  .word EXTI10_15_IRQn_handler
  .word RTC_alarm_IRQn_handler
  .word USB_wakeup_IRQn_handler
  .word 0
  .word 0
  .word 0
  .word 0
  .word 0
  .word EXMC_IRQn_handler
  .word 0
  .word TIM4_IRQn_handler
  .word SPI2_IRQn_handler
  .word UART3_IRQn_handler
  .word UART4_IRQn_handler
  .word TIM5_IRQn_handler
  .word TIM6_IRQn_handler
  .word DMA1_chan0_IRQn_handler
  .word DMA1_chan1_IRQn_handler
  .word DMA1_chan2_IRQn_handler
  .word DMA1_chan3_IRQn_handler
  .word DMA1_chan4_IRQn_handler
  .word 0
  .word 0
  .word CAN1_TX_IRQn_handler
  .word CAN1_RX0_IRQn_handler
  .word CAN1_RX1_IRQn_handler
  .word CAN1_EWMC_IRQn_handler
  .word USB_IRQn_handler

  # /*
  #  * Weak aliases to point each exception hadnler to the
  #  * 'default_interrupt_handler', unless the application defines
  #  * a function with the same name to override the reference.
  #  */
  .weak eclic_msip_handler
  .set  eclic_msip_handler,default_interrupt_handler
  .weak eclic_mtip_handler
  .set  eclic_mtip_handler,default_interrupt_handler
  .weak eclic_bwei_handler
  .set  eclic_bwei_handler,default_interrupt_handler
  .weak eclic_pmovi_handler
  .set  eclic_pmovi_handler,default_interrupt_handler
  .weak watchdog_IRQn_handler
  .set  watchdog_IRQn_handler,default_interrupt_handler
  .weak LVD_IRQn_handler
  .set  LVD_IRQn_handler,default_interrupt_handler
  .weak tamper_IRQn_handler
  .set  tamper_IRQn_handler,default_interrupt_handler
  .weak RTC_IRQn_handler
  .set  RTC_IRQn_handler,default_interrupt_handler
  .weak FMC_IRQn_handler
  .set  FMC_IRQn_handler,default_interrupt_handler
  .weak RCU_IRQn_handler
  .set  RCU_IRQn_handler,default_interrupt_handler
  .weak EXTI0_IRQn_handler
  .set  EXTI0_IRQn_handler,default_interrupt_handler
  .weak EXTI1_IRQn_handler
  .set  EXTI1_IRQn_handler,default_interrupt_handler
  .weak EXTI2_IRQn_handler
  .set  EXTI2_IRQn_handler,default_interrupt_handler
  .weak EXTI3_IRQn_handler
  .set  EXTI3_IRQn_handler,default_interrupt_handler
  .weak EXTI4_IRQn_handler
  .set  EXTI4_IRQn_handler,default_interrupt_handler
  .weak DMA0_chan0_IRQn_handler
  .set  DMA0_chan0_IRQn_handler,default_interrupt_handler
  .weak DMA0_chan1_IRQn_handler
  .set  DMA0_chan1_IRQn_handler,default_interrupt_handler
  .weak DMA0_chan2_IRQn_handler
  .set  DMA0_chan2_IRQn_handler,default_interrupt_handler
  .weak DMA0_chan3_IRQn_handler
  .set  DMA0_chan3_IRQn_handler,default_interrupt_handler
  .weak DMA0_chan4_IRQn_handler
  .set  DMA0_chan4_IRQn_handler,default_interrupt_handler
  .weak DMA0_chan5_IRQn_handler
  .set  DMA0_chan5_IRQn_handler,default_interrupt_handler
  .weak DMA0_chan6_IRQn_handler
  .set  DMA0_chan6_IRQn_handler,default_interrupt_handler
  .weak ADC0_1_IRQn_handler
  .set  ADC0_1_IRQn_handler,default_interrupt_handler
  .weak CAN0_TX_IRQn_handler
  .set  CAN0_TX_IRQn_handler,default_interrupt_handler
  .weak CAN0_RX0_IRQn_handler
  .set  CAN0_RX0_IRQn_handler,default_interrupt_handler
  .weak CAN0_RX1_IRQn_handler
  .set  CAN0_RX1_IRQn_handler,default_interrupt_handler
  .weak CAN0_EWMC_IRQn_handler
  .set  CAN0_EWMC_IRQn_handler,default_interrupt_handler
  .weak EXTI5_9_IRQn_handler
  .set  EXTI5_9_IRQn_handler,default_interrupt_handler
  .weak TIM0_break_IRQn_handler
  .set  TIM0_break_IRQn_handler,default_interrupt_handler
  .weak TIM0_update_IRQn_handler
  .set  TIM0_update_IRQn_handler,default_interrupt_handler
  .weak TIM0_trigger_commutation_IRQn_handler
  .set  TIM0_trigger_commutation_IRQn_handler,default_interrupt_handler
  .weak TIM0_channel_IRQn_handler
  .set  TIM0_channel_IRQn_handler,default_interrupt_handler
  .weak TIM1_IRQn_handler
  .set  TIM1_IRQn_handler,default_interrupt_handler
  .weak TIM2_IRQn_handler
  .set  TIM2_IRQn_handler,default_interrupt_handler
  .weak TIM3_IRQn_handler
  .set  TIM3_IRQn_handler,default_interrupt_handler
  .weak I2C0_EV_IRQn_handler
  .set  I2C0_EV_IRQn_handler,default_interrupt_handler
  .weak I2C0_ER_IRQn_handler
  .set  I2C0_ER_IRQn_handler,default_interrupt_handler
  .weak I2C1_EV_IRQn_handler
  .set  I2C1_EV_IRQn_handler,default_interrupt_handler
  .weak I2C1_ER_IRQn_handler
  .set  I2C1_ER_IRQn_handler,default_interrupt_handler
  .weak SPI0_IRQn_handler
  .set  SPI0_IRQn_handler,default_interrupt_handler
  .weak SPI1_IRQn_handler
  .set  SPI1_IRQn_handler,default_interrupt_handler
  .weak USART0_IRQn_handler
  .set  USART0_IRQn_handler,default_interrupt_handler
  .weak USART1_IRQn_handler
  .set  USART1_IRQn_handler,default_interrupt_handler
  .weak USART2_IRQn_handler
  .set  USART2_IRQn_handler,default_interrupt_handler
  .weak EXTI10_15_IRQn_handler
  .set  EXTI10_15_IRQn_handler,default_interrupt_handler
  .weak RTC_alarm_IRQn_handler
  .set  RTC_alarm_IRQn_handler,default_interrupt_handler
  .weak USB_wakeup_IRQn_handler
  .set  USB_wakeup_IRQn_handler,default_interrupt_handler
  .weak EXMC_IRQn_handler
  .set  EXMC_IRQn_handler,default_interrupt_handler
  .weak TIM4_IRQn_handler
  .set  TIM4_IRQn_handler,default_interrupt_handler
  .weak SPI2_IRQn_handler
  .set  SPI2_IRQn_handler,default_interrupt_handler
  .weak UART3_IRQn_handler
  .set  UART3_IRQn_handler,default_interrupt_handler
  .weak UART4_IRQn_handler
  .set  UART4_IRQn_handler,default_interrupt_handler
  .weak TIM5_IRQn_handler
  .set  TIM5_IRQn_handler,default_interrupt_handler
  .weak TIM6_IRQn_handler
  .set  TIM6_IRQn_handler,default_interrupt_handler
  .weak DMA1_chan0_IRQn_handler
  .set  DMA1_chan0_IRQn_handler,default_interrupt_handler
  .weak DMA1_chan1_IRQn_handler
  .set  DMA1_chan1_IRQn_handler,default_interrupt_handler
  .weak DMA1_chan2_IRQn_handler
  .set  DMA1_chan2_IRQn_handler,default_interrupt_handler
  .weak DMA1_chan3_IRQn_handler
  .set  DMA1_chan3_IRQn_handler,default_interrupt_handler
  .weak DMA1_chan4_IRQn_handler
  .set  DMA1_chan4_IRQn_handler,default_interrupt_handler
  .weak CAN1_TX_IRQn_handler
  .set  CAN1_TX_IRQn_handler,default_interrupt_handler
  .weak CAN1_RX0_IRQn_handler
  .set  CAN1_RX0_IRQn_handler,default_interrupt_handler
  .weak CAN1_RX1_IRQn_handler
  .set  CAN1_RX1_IRQn_handler,default_interrupt_handler
  .weak CAN1_EWMC_IRQn_handler
  .set  CAN1_EWMC_IRQn_handler,default_interrupt_handler
  .weak USB_IRQn_handler
  .set  USB_IRQn_handler,default_interrupt_handler

# /*
#  * A 'default' interrupt handler, in case an interrupt triggers
#  * without a handler being defined.
#  */
.align 6
.section .text.default_interrupt_handler,"ax",%progbits
default_interrupt_handler:
    default_interrupt_loop:
      j default_interrupt_loop

.global reset_handler  #global name (without this linker can't find function)
.type reset_handler, @function
reset_handler:
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# MANUAL PC move from 0x0000.... to 0x0800.... (PC always start from 0 and only maps on 0x0800 0000).
# without this relativetily PC commands gets wrong PC values and all crashes
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  lui a0, 0x08000     #32bits command   set a0=0x0800 0000  
  addi a0, a0, 0x18c   #16bits command   add to a0 8
  jr   a0             #go to _start
_start:             # address 0x0800 0008    
  csrc CSR_MSTATUS, MSTATUS_MIE # disable interrupt
  la s1, _stack_end
  la s0, 0x20008000  
  bne s0, s1, _start  # check if PC on 0x0800....
  mv sp, s1

#Set the vector table's base address.
  la   a0, vtable
  csrw CSR_MTVT, a0

  # Set non-vectored interrupts to use the default handler.
  # (That will gracefully crash the program,
  #  so only use vectored interrupts for now.)
  la   a0, default_interrupt_handler
  csrw CSR_MTVEC, a0
#copy data section to RAM
  la a0, _data_load
  la a1, _sdata
  la a2, _edata
  bgeu a1, a2, copy_data_end    #if(a1>=a2) goto addr
copy_data_loop: # else 
  lw t0, (a0)   # 
  sw t0, (a1)   # copy word from FLASH data to RAM data
  addi a0, a0, 4
  addi a1, a1, 4
    bltu a1, a2, copy_data_loop #if(a1<a2) goto addr
copy_data_end:
# Clear [bss] section
  la a0, _sbss
  la a1, _ebss
  bgeu a0, a1, clear_bss_end
clear_bss_loop:
  sw zero, (a0)     # fill zeroes
  addi a0, a0, 4
    bltu a0, a1, clear_bss_loop
clear_bss_end:
    nop    
    #jal  ra, main
    call main




